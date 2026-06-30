---
name: read-wiki-via-mcp
description: >-
  Read and write Confluence/wiki pages through the local Atlassian MCP SSE
  service. Use when the user asks to 读取 wiki、写入 wiki、更新 Confluence、
  新建页面、修改页面、添加评论、上传附件、read wiki page, fetch Confluence page,
  create/update/delete/move Confluence content, or use MCP with a
  wiki.shterm.com /pages/viewpage.action?pageId=... URL.
---

# Manage Wiki via MCP

## Purpose

Use the local Atlassian MCP service to read and write Confluence wiki content.
Prefer read-before-write and preview-first for any change that mutates an
existing page.

## Common Setup

1. Check the project `AGENTS.md` first when working inside a repository.
2. Confirm the local MCP service is configured and reachable:

```powershell
Get-Content -LiteralPath $env:USERPROFILE\.codex\config.toml
Test-NetConnection -ComputerName localhost -Port 9000
curl.exe -i -N --max-time 5 http://localhost:9000/sse
```

Expected SSE response includes:

```text
event: endpoint
data: /messages/?session_id=...
```

3. Extract `pageId` from URLs like:

```text
https://wiki.shterm.com/pages/viewpage.action?pageId=465733303
```

## Read Workflow

Prefer the helper script:

```powershell
python skill/read-wiki-via-mcp/scripts/read_confluence_page.py --url "https://wiki.shterm.com/pages/viewpage.action?pageId=465733303"
```

Or read directly by page ID:

```powershell
python skill/read-wiki-via-mcp/scripts/read_confluence_page.py --page-id 465733303
```

Summarize the returned page title, id, space, version, URL, attachments, and
the user-requested content. Do not paste very long pages in full unless the user
explicitly asks for the raw content.

Useful read tools:

- `confluence_search`: search by plain text or CQL.
- `confluence_get_page`: get content by `page_id`, or by `title` + `space_key`.
- `confluence_get_page_children`: list child pages.
- `confluence_get_space_page_tree`: inspect a space hierarchy before creating
  or moving pages.
- `confluence_get_comments`, `confluence_get_labels`,
  `confluence_get_attachments`: inspect related page metadata.
- `confluence_get_page_history`, `confluence_get_page_diff`: compare versions
  before or after an update.

## Write Workflow

For write operations, follow this sequence:

1. Identify the target page, parent page, or space.
2. Read the existing page or tree first when changing existing content.
3. Prepare the exact title/content/comment/attachment operation.
4. If the user did not provide final wording or explicitly authorize the write,
   show a concise preview and ask for confirmation before calling a mutating
   tool.
5. Execute one write operation at a time.
6. Read back or report the returned id, title, URL, version, and any MCP error.

Write tools and required arguments:

```text
confluence_create_page(space_key, title, content, parent_id?, content_format?)
confluence_update_page(page_id, title, content, is_minor_edit?, version_comment?, parent_id?, content_format?)
confluence_add_comment(page_id, body)
confluence_reply_to_comment(comment_id, body)
confluence_add_label(page_id, name)
confluence_upload_attachment(content_id, file_path, comment?, minor_edit?)
confluence_upload_attachments(content_id, file_paths, comment?, minor_edit?)
confluence_move_page(page_id, target_parent_id?, target_space_key?, position?)
```

Destructive tools require explicit user confirmation in the current turn:

```text
confluence_delete_page(page_id)
confluence_delete_attachment(attachment_id)
```

Use `content_format: "markdown"` by default unless the user provides Confluence
wiki markup or storage-format HTML. Use `is_minor_edit: true` only when the user
asks to avoid notifications or the edit is clearly mechanical.

## MCP Details

The default service endpoint is:

```text
http://localhost:9000/sse
```

The helper script performs:

- SSE connection to `/sse`
- JSON-RPC `initialize`
- `notifications/initialized`
- `tools/call` with the requested Confluence tool

Example read call:

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/call",
  "params": {
    "name": "confluence_get_page",
    "arguments": {
      "page_id": "<pageId>"
    }
  }
}
```

Example update call:

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "confluence_update_page",
    "arguments": {
      "page_id": "<pageId>",
      "title": "<current or new title>",
      "content": "<full replacement page body>",
      "content_format": "markdown",
      "version_comment": "<short change reason>"
    }
  }
}
```

`confluence_update_page` replaces the page body. Always include the complete
desired page content, not only a patch fragment.

## Troubleshooting

- If port `9000` is closed, the local Atlassian MCP service is not running.
- If `/sse` does not return an endpoint event, the service is not speaking MCP
  SSE correctly.
- If `initialize` succeeds but `confluence_get_page` fails, report the MCP error
  and check page permissions or whether the page ID is valid.
- If a write tool returns read-only mode or permission errors, do not retry with
  destructive alternatives; report the permission problem.
- If Windows console output fails with encoding errors, set:

```powershell
$env:PYTHONIOENCODING='utf-8'
```
