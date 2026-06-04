#!/usr/bin/env python3
"""Execute a single command on a remote Linux host over SSH and return JSON."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess
import sys
import time


FORBIDDEN_COMMANDS = (
    "rm -rf /",
    "shutdown",
    "reboot",
    "mkfs",
)


def is_forbidden(command: str) -> bool:
    lowered = command.lower()
    return any(item in lowered for item in FORBIDDEN_COMMANDS)


def run_ssh(host: str, user: str, command: str, port: int, timeout: int, identity_file: str | None = None) -> dict:
    if is_forbidden(command):
        return {
            "success": False,
            "exitCode": 126,
            "stdout": "",
            "stderr": "Refusing to run forbidden remote command.",
            "duration": 0,
            "command": command,
        }

    target = f"{user}@{host}"
    cmd = ["ssh", "-p", str(port), target, command]
    if identity_file:
        cmd[3:3] = ["-i", str(Path(identity_file).expanduser())]
    start = time.monotonic()
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    duration = round(time.monotonic() - start, 3)
    return {
        "success": proc.returncode == 0,
        "exitCode": proc.returncode,
        "stdout": proc.stdout,
        "stderr": proc.stderr,
        "duration": duration,
        "command": command,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Execute a remote SSH command.")
    parser.add_argument("--host", required=True)
    parser.add_argument("--user", required=True)
    parser.add_argument("--command", required=True)
    parser.add_argument("--port", type=int, default=22)
    parser.add_argument("--identity-file", help="SSH private key path for key-based login.")
    parser.add_argument("--timeout", type=int, default=300)
    args = parser.parse_args()

    try:
        result = run_ssh(args.host, args.user, args.command, args.port, args.timeout, args.identity_file)
    except subprocess.TimeoutExpired as exc:
        result = {
            "success": False,
            "exitCode": 124,
            "stdout": exc.stdout or "",
            "stderr": exc.stderr or "SSH command timed out.",
            "duration": args.timeout,
            "command": args.command,
        }

    print(json.dumps(result, ensure_ascii=False))
    return 0 if result["success"] else 1


if __name__ == "__main__":
    sys.exit(main())
