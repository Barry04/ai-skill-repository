# Cursor 兼容层说明（可选）

> 本文是兼容层说明，不是主安装入口。主入口请看 `skill/agent-integration.md`。

## 为什么还有这个文件

为了兼容仍依赖 `.cursor/rules/*.mdc` 的使用方式，仓库保留了 `integrations/cursor/project-skill.mdc` 示例。

但这不是必选步骤，也不是核心设计。

## 统一方案下的定位

- 核心协议：`<repo>/.project-skill.json` + schema；
- 统一安装：`scripts/install-skill.ps1`；
- Cursor 目录仅是兼容入口，不存放主数据。

## 必须遵守

- `project-skill.json` 只允许放在项目根目录；
- 禁止在 `.cursor/rules/` 下创建 `project-skill.json`；
- 若根目录缺失文件，按统一初始化逻辑自动创建。
# `.project-skill.json` 工具适配说明（最小可落地）

> 推荐优先阅读：`skill/agent-integration.md`（工具无关版本）。本文保留 Cursor 适配细节。

## 仓库里有什么


| 路径                                      | 作用                              |
| --------------------------------------- | ------------------------------- |
| `.project-skill.json`                   | 实际使用的约定数据（可提交到 Git）             |
| `.project-skill.example.json`           | 与上面同结构的示例副本，便于复制到新项目            |
| `schema/project-skill.schema.json`      | JSON Schema，可在编辑器或 CI 里做校验      |
| `integrations/cursor/project-skill.mdc` | Cursor 适配示例：指示 Agent 读取并按规则选用条目 |


根级 `.project-skill.json` 已包含 `"$schema": "./schema/project-skill.schema.json"`，便于编辑器校验；拷贝到新项目时请**保留相对路径**或改为指向你放置的 schema 的 URL。

## 在新项目中落地（三步）

1. **复制文件**
  将 `schema/project-skill.schema.json`、`.project-skill.example.json`（或本仓库的 `.project-skill.json`）拷入新仓库根目录；把示例重命名为 `.project-skill.json` 并按项目修改 `skills`。
2. **选择一个 Agent 适配层（按你的工具）**
  - **Cursor**：将适配文件放到 `.cursor/rules/project-skill.mdc`（可由 `integrations/cursor/project-skill.mdc` 复制而来）。
  - **Claude Code**：将说明写入 `~/.claude/skills/<skill-name>/SKILL.md`，核心逻辑同样是“读取 `.project-skill.json` 并按规则筛选注入”。
  - **其他工具**：只要能在会话前读取项目文件并注入上下文，即可复用同一套规则。
3. **（可选）校验**
  在 CI 或 pre-commit 中对 `.project-skill.json` 运行 `ajv`/`check-jsonschema` 等工具，指向 `schema/project-skill.schema.json`。

## 缺失文件时的自动初始化（必须）

适配层读取前应执行：

1. 若 `<repo>/.project-skill.json` 存在，直接读取；
2. 若不存在且 `<repo>/.project-skill.example.json` 存在，复制生成；
3. 若两者都不存在，创建最小空文件：

```json
{
  "$schema": "./schema/project-skill.schema.json",
  "version": 1,
  "updated_at": "1970-01-01T00:00:00Z",
  "skills": []
}
```

并且只允许操作项目根目录文件，禁止在 `.cursor/` 或 `~/.claude/` 下创建主数据文件。

## 与 `skill/evolving-skill.md` 的关系

- `evolving-skill.md` 描述**机制与生命周期**（创建、演进、衰减等）。  
- 本目录与 `schema/`、`integrations/` 提供**最小文件形态 + 适配入口**。  
- 自动化写回、关键词命中、Hook 触发等仍可按设计文档自行扩展；本衔接层不依赖额外服务。

## 常见问题

**Q：规则里为什么不直接粘贴整份 JSON？**  
A：遵守「少而精」与 token 经济；由 Agent 在需要时 `Read` 文件即可。

**Q：多包 monorepo 怎么办？**  
A：用 `scope` 区分（例如 `path:packages/web`），在规则中增加一句：优先选用 `scope` 与当前编辑路径前缀匹配的条目。

**Q：为什么不把路径写死成 `.cursor/rules/`？**  
A：`Skill Engine` 的核心是数据协议（`.project-skill.json` + schema），不是某个 IDE 的目录结构。`.cursor/rules/` 只是 Cursor 的一种适配实现。

**Q：`project-skill.json` 要不要放到 `.cursor/rules/`？**  
A：不要。`project-skill.json` 必须放在项目根目录（`<repo>/.project-skill.json`）。`.cursor/rules/` 只放 `project-skill.mdc` 这类规则文件。