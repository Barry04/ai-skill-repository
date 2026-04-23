# `.project-skill.json` 与 Cursor Rule 衔接说明（最小可落地）

## 仓库里有什么

| 路径 | 作用 |
|------|------|
| `.project-skill.json` | 实际使用的约定数据（可提交到 Git） |
| `.project-skill.example.json` | 与上面同结构的示例副本，便于复制到新项目 |
| `schema/project-skill.schema.json` | JSON Schema，可在编辑器或 CI 里做校验 |
| `.cursor/rules/project-skill.mdc` | Cursor 规则：指示 Agent 读取并按规则选用条目 |

根级 `.project-skill.json` 已包含 `"$schema": "./schema/project-skill.schema.json"`，便于编辑器校验；拷贝到新项目时请**保留相对路径**或改为指向你放置的 schema 的 URL。

## 在新项目中落地（三步）

1. **复制文件**  
   将 `schema/project-skill.schema.json`、`.project-skill.example.json`（或本仓库的 `.project-skill.json`）拷入新仓库根目录；把示例重命名为 `.project-skill.json` 并按项目修改 `skills`。

2. **安装 Cursor 规则**  
   在新仓库创建 `.cursor/rules/`，放入 `project-skill.mdc`（可直接复制本仓库同名文件）。按需修改 frontmatter：  
   - `alwaysApply: true`：每次对话都会带上「去读 JSON」的短说明（**不会**自动把整份 JSON 塞进上下文，仍需 Agent 读文件）。  
   - 若希望减轻全局噪音，可改为 `alwaysApply: false` 并设置 `globs`，例如仅在 `**/*.ts` 或 `backend/**/*.java` 打开时生效。

3. **（可选）校验**  
   在 CI 或 pre-commit 中对 `.project-skill.json` 运行 `ajv`/`check-jsonschema` 等工具，指向 `schema/project-skill.schema.json`。

## 与 `skill/evolving-skill.md` 的关系

- `evolving-skill.md` 描述**机制与生命周期**（创建、演进、衰减等）。  
- 本目录与 `schema/`、`.cursor/rules/` 提供**最小文件形态 + Cursor 侧入口**。  
- 自动化写回、关键词命中、Hook 触发等仍可按设计文档自行扩展；本衔接层不依赖额外服务。

## 常见问题

**Q：规则里为什么不直接粘贴整份 JSON？**  
A：遵守「少而精」与 token 经济；由 Agent 在需要时 `Read` 文件即可。

**Q：多包 monorepo 怎么办？**  
A：用 `scope` 区分（例如 `path:packages/web`），在规则中增加一句：优先选用 `scope` 与当前编辑路径前缀匹配的条目。
