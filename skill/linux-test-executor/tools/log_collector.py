#!/usr/bin/env python3
"""Download a remote log file with scp and return JSON."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess
import sys
import time


def collect(
    host: str,
    user: str,
    remote_path: str,
    local_dir: Path,
    port: int,
    timeout: int,
    identity_file: str | None = None,
) -> dict:
    local_dir.mkdir(parents=True, exist_ok=True)
    source = f"{user}@{host}:{remote_path}"
    cmd = ["scp", "-P", str(port), source, str(local_dir)]
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
        "remotePath": remote_path,
        "localDir": str(local_dir),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Collect a remote log with scp.")
    parser.add_argument("--host", required=True)
    parser.add_argument("--user", required=True)
    parser.add_argument("--remote-path", required=True)
    parser.add_argument("--local-dir", default="logs")
    parser.add_argument("--port", type=int, default=22)
    parser.add_argument("--identity-file", help="SSH private key path for key-based scp download.")
    parser.add_argument("--timeout", type=int, default=300)
    args = parser.parse_args()

    try:
        result = collect(args.host, args.user, args.remote_path, Path(args.local_dir), args.port, args.timeout, args.identity_file)
    except subprocess.TimeoutExpired as exc:
        result = {
            "success": False,
            "exitCode": 124,
            "stdout": exc.stdout or "",
            "stderr": exc.stderr or "scp download timed out.",
            "duration": args.timeout,
            "remotePath": args.remote_path,
            "localDir": args.local_dir,
        }

    print(json.dumps(result, ensure_ascii=False))
    return 0 if result["success"] else 1


if __name__ == "__main__":
    sys.exit(main())
