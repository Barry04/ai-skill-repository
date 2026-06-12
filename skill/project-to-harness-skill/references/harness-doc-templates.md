# Harness 文档模板

## AGENTS.md（≤60 行）

```markdown
# <项目名>

<一句话简介>

## 阅读顺序

1. docs/harness/architecture.md
2. docs/harness/commands.md
3. 按任务查下方 Skills 索引

## Docs

| 文档 | 路径 |
|------|------|
| 架构 | docs/harness/architecture.md |
| 命令 | docs/harness/commands.md |
| 约定 | docs/harness/conventions.md |
| 知识索引 | docs/harness/knowledge-index.md |
| Skill 登记 | docs/harness/skill-registry.md |

## Skills

| Skill | 路径 | 何时用 |
|-------|------|--------|
| ... | skills/.../SKILL.md | ... |

## Agent 入口

详细规则在 `docs/harness/` 与 `skills/`；本文件仅作索引。
```

## docs/harness/README.md

```markdown
# Harness 文档

由 **project-to-harness-skill** 生成。业务源码与构建/部署配置未修改。
```

## knowledge-index.md / conventions.md / architecture.md / commands.md

结构同前版；`conventions.md` 须包含 Phase 2.5 决策为 `convention-only` 的条目及评分明细。

## skill-registry.md

见 `output-layout.md` 字段表；生成完成后为 Phase 4 权威登记。
