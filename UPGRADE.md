# 维护说明

## 新增 Skill

1. `skill/<skill-name>/` — 小写短横线命名
2. 写 `SKILL.md`，frontmatter 仅 `name` + `description`
3. `description` 写清**做什么**和**什么时候用**（含触发词）
4. 正文短、可执行；大块放 `references/`，脚本放 `tools/`
5. 更新根目录 `AGENTS.md` 索引表

模板：

```markdown
---
name: skill-name
description: What it does and when to use it (triggers, errors, workflows).
---

# Title

## Purpose
...

## <Topic>
Triggers: ...
Rules: ...
```

## 更新已有 Skill

- 触发词重叠 → 合并进已有 Skill，不新建
- 敏感值用 `<host>` `<port>` `<user>` `<key_path>` 占位
- 不存密码、token、私钥、生产细节

## 沉淀流程

Agent 规则见 `skill/evolving-skill/SKILL.md`。要点：

- 验证通过 + 可复用 → 问用户
- 用户同意 → 写入并告知路径
- 用户拒绝 → 本会话不再追问同一条

## 质量检查

- [ ] 目录名 = `name`
- [ ] `description` 含触发场景
- [ ] `SKILL.md` 可操作，非长篇背景
- [ ] `AGENTS.md` 索引已更新
- [ ] 无敏感信息

## Skill 说明

| Skill | 备注 |
|-------|------|
| project-to-harness-skill | 目标项目生成 Harness 文档 + `skills/` + `skill-registry.md`；见 `skill/project-to-harness-skill/references/` |

旧名 `project-harness-bootstrap` 已重命名为 `project-to-harness-skill`。

## 历史迁移

- 根目录 `skill.md` → `skill/java-backend-troubleshooting/SKILL.md`
- `skill/evolving-skill.md` → `skill/evolving-skill/SKILL.md`
