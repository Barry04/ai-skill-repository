#!/usr/bin/env python3
"""Read a Confluence page through the local Atlassian MCP SSE service."""

from __future__ import annotations

import argparse
import json
import re
import sys
import threading
import time
from typing import Any
from urllib import request


def extract_page_id(url: str) -> str | None:
    match = re.search(r"[?&]pageId=(\d+)", url)
    return match.group(1) if match else None


class McpSseClient:
    def __init__(self, base_url: str) -> None:
        self.base_url = base_url.rstrip("/")
        self.message_url: str | None = None
        self.messages: list[dict[str, Any]] = []
        self.ready = threading.Event()
        self.stop = False

    def start(self) -> None:
        thread = threading.Thread(target=self._read_sse, daemon=True)
        thread.start()
        if not self.ready.wait(8):
            raise RuntimeError("MCP SSE endpoint did not provide a message URL.")

    def close(self) -> None:
        self.stop = True

    def _read_sse(self) -> None:
        req = request.Request(
            self.base_url + "/sse",
            headers={"Accept": "text/event-stream"},
        )
        with request.urlopen(req, timeout=15) as resp:
            data_lines: list[str] = []
            for raw in resp:
                line = raw.decode("utf-8", errors="replace").rstrip("\n")
                if line.startswith("data:"):
                    data_lines.append(line.split(":", 1)[1].lstrip())
                elif line.strip() == "":
                    if data_lines:
                        self._handle_sse_data("\n".join(data_lines))
                    data_lines = []
                if self.stop:
                    break

    def _handle_sse_data(self, data: str) -> None:
        if data.startswith("/messages/"):
            self.message_url = self.base_url + data
            self.ready.set()
            return
        if data.startswith("{"):
            self.messages.append(json.loads(data))

    def post(self, payload: dict[str, Any]) -> int:
        if not self.message_url:
            raise RuntimeError("MCP message URL is not ready.")
        req = request.Request(
            self.message_url,
            data=json.dumps(payload).encode("utf-8"),
            method="POST",
            headers={"Content-Type": "application/json"},
        )
        with request.urlopen(req, timeout=30) as resp:
            return resp.status

    def wait_for_id(self, message_id: int, timeout: int = 30) -> dict[str, Any]:
        deadline = time.time() + timeout
        while time.time() < deadline:
            for msg in self.messages:
                if msg.get("id") == message_id:
                    return msg
            time.sleep(0.1)
        raise TimeoutError(f"Timed out waiting for MCP response id={message_id}.")


def read_page(base_url: str, page_id: str) -> dict[str, Any]:
    client = McpSseClient(base_url)
    try:
        client.start()
        client.post(
            {
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2024-11-05",
                    "capabilities": {},
                    "clientInfo": {
                        "name": "read-wiki-via-mcp",
                        "version": "0.1.0",
                    },
                },
            }
        )
        init = client.wait_for_id(1)
        client.post(
            {
                "jsonrpc": "2.0",
                "method": "notifications/initialized",
                "params": {},
            }
        )
        client.post(
            {
                "jsonrpc": "2.0",
                "id": 2,
                "method": "tools/call",
                "params": {
                    "name": "confluence_get_page",
                    "arguments": {"page_id": page_id},
                },
            }
        )
        page = client.wait_for_id(2)
        return {
            "serverInfo": init.get("result", {}).get("serverInfo"),
            "pageId": page_id,
            "response": page,
        }
    finally:
        client.close()


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Read a Confluence page through the local Atlassian MCP service."
    )
    parser.add_argument("--url", help="Confluence page URL containing pageId.")
    parser.add_argument("--page-id", help="Confluence page ID.")
    parser.add_argument("--base-url", default="http://localhost:9000")
    args = parser.parse_args()

    page_id = args.page_id or (extract_page_id(args.url) if args.url else None)
    if not page_id:
        parser.error("Provide --page-id or --url with a pageId query parameter.")

    try:
        result = read_page(args.base_url, page_id)
    except Exception as exc:
        print(json.dumps({"ok": False, "error": str(exc)}, ensure_ascii=False))
        return 1

    print(json.dumps({"ok": True, **result}, ensure_ascii=False, indent=2))
    response = result.get("response", {})
    return 0 if not response.get("error") else 1


if __name__ == "__main__":
    sys.exit(main())
