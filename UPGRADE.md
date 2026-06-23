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

## 触发率维护

Skill 触发率低时，优先改 `description` 和 `AGENTS.md`，不要先堆正文。

`description` 必须尽量覆盖：

- 中文任务说法：例如 `远程测试`、`事务不回滚`、`初始化 AGENTS.md`
- 英文任务说法：例如 `remote Linux testing`、`Spring transaction rollback`
- 常见报错文本：例如 `Permission denied`、`No route to host`
- 工具 / 框架名：例如 `SSH`、`scp`、`Spring Boot`、`MyBatis`
- 明确触发语：强触发场景可写 `MUST use when ...`

检查清单：

- [ ] `AGENTS.md` 有任务开始读取规则
- [ ] `AGENTS.md` 索引表包含该 Skill
- [ ] `description` 包含中英文触发词
- [ ] 常见用户说法没有只藏在正文
- [ ] Skill 目录存在 `SKILL.md`

## 沉淀流程

Agent 规则见 `skill/evolving-skill/SKILL.md`。要点：

- 验证通过 + 可复用 → 问用户
- 用户同意 → 写入**当前项目** `skill/`，并更新项目 `AGENTS.md`
- 禁止写入全局 Skill 目录（`evolving-skill` 协议除外）
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
`project-to-harness-skill` 负责 Harness 化、AGENTS.md、Skill 索引和项目级 Skill 生成。

## 历史迁移

- GitHub 仓库名：**ai-skill-repository**；项目 / 协议名：**evolving-skill**（二者不同，文档与链接勿混用）
- 根目录 `skill.md` → `skill/java-backend-troubleshooting/SKILL.md`
- `skill/evolving-skill.md` → `skill/evolving-skill/SKILL.md`
- `readme_zh.md` → 内容并入 `README.md`（中文主文档），英文见 `README.en.md`
