#!/usr/bin/env python3
"""Upload artifacts, execute a remote command, collect logs, and return JSON."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import shlex
import subprocess
import sys
import time

from file_uploader import upload
from log_collector import collect
from ssh_executor import is_forbidden, run_ssh


NETWORK_FAILURE_KEYWORDS = (
    "connection refused",
    "no route to host",
    "host unreachable",
    "connection timed out",
    "operation timed out",
)


def load_config(config_path: str | None) -> dict:
    if not config_path:
        return {}

    path = Path(config_path).expanduser()
    with path.open("r", encoding="utf-8") as file:
        data = json.load(file)

    if not isinstance(data, dict):
        raise ValueError("Config file must contain a JSON object.")

    return data


def get_value(args: argparse.Namespace, config: dict, name: str, default=None):
    cli_value = getattr(args, name, None)
    if cli_value is not None:
        return cli_value

    camel_name = "".join([name.split("_")[0], *[part.title() for part in name.split("_")[1:]]])
    if name in config:
        return config[name]
    if camel_name in config:
        return config[camel_name]
    return default


def require_value(value, name: str):
    if value in (None, ""):
        raise ValueError(f"Missing required value: {name}. Provide it in --config or as a command-line argument.")
    return value


def summarize(success: bool, exit_code: int, stdout: str, stderr: str) -> str:
    combined = f"{stdout}\n{stderr}".lower()
    if success and exit_code == 0:
        return "test passed"
    if any(text in combined for text in NETWORK_FAILURE_KEYWORDS):
        return "connection failure; check host, firewall, and SSH service"
    if "permission denied" in combined:
        return "permission failure; check SSH credentials, chmod, or user privilege"
    if "address already in use" in combined or "port occupied" in combined:
        return "deployment failure; port is already occupied"
    if "beancreationexception" in combined or "nosuchmethoderror" in combined or "exception" in combined:
        return "java startup failure; inspect stack trace and caused-by chain"
    return "test failed"


def should_retry(result: dict) -> bool:
    combined = f"{result.get('stdout', '')}\n{result.get('stderr', '')}".lower()
    return any(text in combined for text in NETWORK_FAILURE_KEYWORDS)


def run_with_retries(fn, attempts: int) -> dict:
    last_result = None
    for attempt in range(1, attempts + 1):
        last_result = fn()
        last_result["attempt"] = attempt
        if last_result.get("success") or not should_retry(last_result):
            return last_result
        time.sleep(min(attempt, 3))
    return last_result or {"success": False, "exitCode": 1, "stdout": "", "stderr": "No execution attempted."}


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run a remote Linux test workflow.",
        argument_default=argparse.SUPPRESS,
    )
    parser.add_argument("--config", help="JSON config file with connection defaults.")
    parser.add_argument("--host")
    parser.add_argument("--user")
    parser.add_argument(
        "--upload",
        action="append",
        default=argparse.SUPPRESS,
        help="Local file or directory to upload. Repeatable.",
    )
    parser.add_argument("--remote-dir")
    parser.add_argument("--run", help="Remote command to execute.")
    parser.add_argument("--log-path", help="Remote log path to download after execution.")
    parser.add_argument("--local-log-dir")
    parser.add_argument("--port", type=int)
    parser.add_argument("--identity-file", help="SSH private key path for key-based login.")
    parser.add_argument("--timeout", type=int)
    parser.add_argument("--retries", type=int)
    parser.add_argument("--skip-preflight", action="store_true", default=argparse.SUPPRESS)
    args = parser.parse_args()

    try:
        config = load_config(getattr(args, "config", None))
        args.host = require_value(get_value(args, config, "host"), "host")
        args.user = require_value(get_value(args, config, "user"), "user")
        args.run = require_value(get_value(args, config, "run"), "run")
        args.upload = get_value(args, config, "upload", [])
        args.remote_dir = get_value(args, config, "remote_dir", "/tmp/linux-test-executor")
        args.log_path = get_value(args, config, "log_path")
        args.local_log_dir = get_value(args, config, "local_log_dir", "logs")
        args.port = int(get_value(args, config, "port", 22))
        args.identity_file = get_value(args, config, "identity_file")
        args.timeout = int(get_value(args, config, "timeout", 300))
        args.retries = int(get_value(args, config, "retries", 3))
        args.skip_preflight = bool(get_value(args, config, "skip_preflight", False))
        if isinstance(args.upload, str):
            args.upload = [args.upload]
    except (OSError, json.JSONDecodeError, ValueError) as exc:
        result = {
            "host": getattr(args, "host", ""),
            "operation": "load-config",
            "success": False,
            "exitCode": 2,
            "duration": 0,
            "stdout": "",
            "stderr": str(exc),
            "uploads": [],
            "logPath": None,
            "summary": "configuration error",
        }
        print(json.dumps(result, ensure_ascii=False))
        return 2

    start = time.monotonic()
    uploads = []
    stdout_parts = []
    stderr_parts = []

    if is_forbidden(args.run):
        result = {
            "host": args.host,
            "operation": "remote-test",
            "success": False,
            "exitCode": 126,
            "duration": 0,
            "stdout": "",
            "stderr": "Refusing to run forbidden remote command.",
            "uploads": [],
            "logPath": args.log_path,
            "summary": "forbidden command rejected",
        }
        print(json.dumps(result, ensure_ascii=False))
        return 1

    if not args.skip_preflight:
        preflight = run_with_retries(
            lambda: run_ssh(args.host, args.user, "hostname", args.port, args.timeout, args.identity_file),
            max(1, args.retries),
        )
        stdout_parts.append(preflight.get("stdout", ""))
        stderr_parts.append(preflight.get("stderr", ""))
        if not preflight.get("success"):
            duration = round(time.monotonic() - start, 3)
            result = {
                "host": args.host,
                "operation": "preflight",
                "success": False,
                "exitCode": preflight.get("exitCode", 1),
                "duration": duration,
                "stdout": "\n".join(stdout_parts),
                "stderr": "\n".join(stderr_parts),
                "uploads": uploads,
                "logPath": args.log_path,
                "summary": summarize(False, preflight.get("exitCode", 1), preflight.get("stdout", ""), preflight.get("stderr", "")),
            }
            print(json.dumps(result, ensure_ascii=False))
            return 1

        mkdir_result = run_ssh(
            args.host,
            args.user,
            f"mkdir -p {shlex.quote(args.remote_dir)}",
            args.port,
            args.timeout,
            args.identity_file,
        )
        stdout_parts.append(mkdir_result.get("stdout", ""))
        stderr_parts.append(mkdir_result.get("stderr", ""))
        if not mkdir_result.get("success"):
            duration = round(time.monotonic() - start, 3)
            result = {
                "host": args.host,
                "operation": "prepare-remote-dir",
                "success": False,
                "exitCode": mkdir_result.get("exitCode", 1),
                "duration": duration,
                "stdout": "\n".join(stdout_parts),
                "stderr": "\n".join(stderr_parts),
                "uploads": uploads,
                "logPath": args.log_path,
                "summary": summarize(False, mkdir_result.get("exitCode", 1), mkdir_result.get("stdout", ""), mkdir_result.get("stderr", "")),
            }
            print(json.dumps(result, ensure_ascii=False))
            return 1

    for item in args.upload:
        upload_result = upload(Path(item), args.host, args.user, args.remote_dir, args.port, args.timeout, args.identity_file)
        uploads.append(upload_result)
        stdout_parts.append(upload_result.get("stdout", ""))
        stderr_parts.append(upload_result.get("stderr", ""))
        if not upload_result.get("success"):
            duration = round(time.monotonic() - start, 3)
            result = {
                "host": args.host,
                "operation": "upload",
                "success": False,
                "exitCode": upload_result.get("exitCode", 1),
                "duration": duration,
                "stdout": "\n".join(stdout_parts),
                "stderr": "\n".join(stderr_parts),
                "uploads": uploads,
                "logPath": args.log_path,
                "summary": summarize(False, upload_result.get("exitCode", 1), upload_result.get("stdout", ""), upload_result.get("stderr", "")),
            }
            print(json.dumps(result, ensure_ascii=False))
            return 1

    run_result = run_with_retries(
        lambda: run_ssh(args.host, args.user, args.run, args.port, args.timeout, args.identity_file),
        max(1, args.retries),
    )
    stdout_parts.append(run_result.get("stdout", ""))
    stderr_parts.append(run_result.get("stderr", ""))

    log_result = None
    if args.log_path:
        log_result = collect(args.host, args.user, args.log_path, Path(args.local_log_dir), args.port, args.timeout, args.identity_file)
        stdout_parts.append(log_result.get("stdout", ""))
        stderr_parts.append(log_result.get("stderr", ""))

    duration = round(time.monotonic() - start, 3)
    success = bool(run_result.get("success")) and (log_result is None or bool(log_result.get("success")))
    exit_code = run_result.get("exitCode", 1)
    result = {
        "host": args.host,
        "operation": "integration-test",
        "success": success,
        "exitCode": exit_code,
        "duration": duration,
        "stdout": "\n".join(stdout_parts),
        "stderr": "\n".join(stderr_parts),
        "uploads": uploads,
        "logPath": args.log_path,
        "logResult": log_result,
        "summary": summarize(success, exit_code, "\n".join(stdout_parts), "\n".join(stderr_parts)),
    }
    print(json.dumps(result, ensure_ascii=False))
    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())
