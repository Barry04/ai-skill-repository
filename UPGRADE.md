# 升级与维护说明

这个仓库按“个人 Skill 仓库”管理。

根目录只放仓库级文档；`skill/` 目录下每个子目录都是一个独立 Skill。

本仓库约定使用小写 `skill/` 作为 Skill 目录名。

## 目标结构

```text
README.md
readme_zh.md
UPGRADE.md
LICENSE
skill/
  evolving-skill/
    SKILL.md
  java-backend-troubleshooting/
    SKILL.md
  linux-test-executor/
    SKILL.md
    references/
    tools/
    assets/
    agents/
```

## 新增 Skill

1. 在 `skill/` 下创建一个小写短横线命名的目录。
2. 在目录里创建 `SKILL.md`。
3. `SKILL.md` 的 YAML frontmatter 只保留 `name` 和 `description`。
4. `description` 要同时说明 Skill 做什么、什么时候应该使用。
5. 正文保持短小、可执行、可复用。
6. 只有确实需要时才添加可选目录：
   - `references/`：较长文档或规则。
   - `tools/`：可重复执行的脚本。
   - `assets/`：模板、示例、配置样例。
   - `agents/`：Agent 展示或发现用元数据。

最小模板：

```markdown
---
name: skill-name
description: What this skill does and when an Agent should use it.
---

# Skill Title

## Purpose

...
```

## 更新已有 Skill

1. 优先合并到已有 Skill，避免重复创建相似 Skill。
2. `SKILL.md` 只放核心规则和流程。
3. 大段说明、示例、排查细节放入 `references/`。
4. 可重复执行的脚本放入 `tools/`。
5. 配置样例、模板文件放入 `assets/`。
6. 不保存密码、token、私钥、凭证或敏感生产环境信息。
7. 涉及环境信息时使用占位符，例如 `<host>`、`<port>`、`<user>`、`<key_path>`。

## 沉淀新经验

Agent 不能静默写入新 Skill。

当对话或执行过程中出现可复用经验时，Agent 应先询问：

```text
这条经验以后可能还会用到：<one-line summary>。
要不要我把它沉淀到项目 skill 里？
```

只有用户明确同意后，才能保存或合并。

## 迁移说明

本次结构调整将仓库从“根目录 `skill.md` + 零散协议文件”迁移为“一个目录一个 Skill”：

- 旧的根目录 `skill.md` 已迁移为 `skill/java-backend-troubleshooting/SKILL.md`。
- 旧的 `skill/evolving-skill.md` 已迁移为 `skill/evolving-skill/SKILL.md`。
- `skill/linux-test-executor/` 保持为独立 Skill，并继续使用其 `references/`、`tools/`、`assets/`、`agents/` 结构。

## 质量检查

每个 Skill 完成前检查：

- 目录名和 `name` 一致。
- `SKILL.md` 有合法 frontmatter。
- `description` 明确说明触发场景。
- 正文可操作，不堆长篇背景。
- 敏感值已替换成占位符。
- 内容对未来任务有复用价值。
