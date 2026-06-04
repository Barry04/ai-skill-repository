#!/usr/bin/env python3
"""Upload a file or directory to a remote Linux host with scp and return JSON."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess
import sys
import time


def upload(
    local_path: Path,
    host: str,
    user: str,
    remote_dir: str,
    port: int,
    timeout: int,
    identity_file: str | None = None,
) -> dict:
    if not local_path.exists():
        return {
            "success": False,
            "exitCode": 2,
            "stdout": "",
            "stderr": f"Local path does not exist: {local_path}",
            "duration": 0,
            "localPath": str(local_path),
            "remoteDir": remote_dir,
        }

    target = f"{user}@{host}:{remote_dir.rstrip('/')}/"
    cmd = ["scp", "-P", str(port)]
    if identity_file:
        cmd.extend(["-i", str(Path(identity_file).expanduser())])
    if local_path.is_dir():
        cmd.append("-r")
    cmd.extend([str(local_path), target])

    start = time.monotonic()
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    duration = round(time.monotonic() - start, 3)
    return {
        "success": proc.returncode == 0,
        "exitCode": proc.returncode,
        "stdout": proc.stdout,
        "stderr": proc.stderr,
        "duration": duration,
        "localPath": str(local_path),
        "remoteDir": remote_dir,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Upload a file or directory with scp.")
    parser.add_argument("--host", required=True)
    parser.add_argument("--user", required=True)
    parser.add_argument("--local", required=True)
    parser.add_argument("--remote-dir", required=True)
    parser.add_argument("--port", type=int, default=22)
    parser.add_argument("--identity-file", help="SSH private key path for key-based scp upload.")
    parser.add_argument("--timeout", type=int, default=300)
    args = parser.parse_args()

    try:
        result = upload(Path(args.local), args.host, args.user, args.remote_dir, args.port, args.timeout, args.identity_file)
    except subprocess.TimeoutExpired as exc:
        result = {
            "success": False,
            "exitCode": 124,
            "stdout": exc.stdout or "",
            "stderr": exc.stderr or "scp upload timed out.",
            "duration": args.timeout,
            "localPath": args.local,
            "remoteDir": args.remote_dir,
        }

    print(json.dumps(result, ensure_ascii=False))
    return 0 if result["success"] else 1


if __name__ == "__main__":
    sys.exit(main())
