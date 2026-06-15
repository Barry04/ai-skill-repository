---
name: evolving-skill
description: >-
  MUST use when evolving project skills. Protocol lives in global skills dir;
  generated or updated skills go to the current project's skill/. Ask the user
  before saving.
---

# Evolving Skill Harness

**evolving-skill** 是演进**协议**（装在全局 Skill 目录）；**生成或演化的 Skill** 写在**当前项目**的 `skill/` 下。

---

## 放在哪里

| 内容 | 位置 | 说明 |
|------|------|------|
| evolving-skill 协议 | `~/.cursor/skills/evolving-skill/` 或 `~/.claude/skills/evolving-skill/` | `install.ps1` / `install.sh` 安装，跨项目通用 |
| 生成 / 演化的 Skill | **当前项目根** `skill/<name>/` | 随项目 Git 版本管理 |
| 项目 Agent 索引 | **当前项目根** `AGENTS.md` | 有新 Skill 时更新索引 |

**禁止**把日常沉淀写到全局 Skill 目录或 `ai-skill-repository` 仓库——除非用户明确要求且当前工作区就是该仓库。

确定项目根：以 Agent 当前工作区根目录为准；多仓库工作区时，经验归属用户正在改动的那个项目。

---

## 使用

任务开始或方向变化时：

1. 读**当前项目** `AGENTS.md`（若有），按问题、报错、模块名匹配 `skill/`
2. 可同时参考全局已安装 Skill（如 `java-backend-troubleshooting`），但**最多共 2 个**高相关 Skill
3. 无匹配且可重复 → 记下缺口，收尾时考虑在项目 `skill/` 新建
4. 无 `AGENTS.md` / `skill/` 时，提示用户先建立项目 Skill 结构（可读项目 `AGENTS.md` 或请用户说明入口）

---

## 演进

**核心：可复用经验提示用户保存到当前项目 `skill/`，禁止静默写入。**

### 值得保存

- 已验证的 bug 根因 + 修复
- 可重复的构建 / 测试 / 部署命令流
- 框架踩坑（Spring 事务、MyBatis 分页等）
- 用户明确纠正：「以后都这样」「不要用 X」
- 远程测试机约定（用 `<host>` `<port>` 等占位符）

### 不要保存

- 密钥、token、生产主机等敏感信息
- 长日志、未验证猜测、一次性对话偏好
- 读代码就能看出的显而易见信息

### 何时问用户

- 问题已解决或流程已跑通，且经验可复用
- 用户刚纠正了做法
- 任务收尾时，还有未问过用户的沉淀项（同类最多 **3** 条）

用户已拒绝的同一条，本会话不再追问。

### 保存话术

```text
💡 可沉淀经验：<一句话摘要>

要保存到当前项目的 skill/<建议名>/ 吗？
- 新建
- 合并到 <已有 skill>
- 暂不
```

用户同意后：

1. 写入 `<项目根>/skill/<name>/SKILL.md`（及可选 `references/`、`tools/`）
2. 更新 `<项目根>/AGENTS.md` 索引
3. 告知完整路径，例如 `my-app/skill/payment-troubleshooting/SKILL.md`

---

## Skill 格式

```text
<project-root>/skill/<skill-name>/
  SKILL.md
  references/       # 可选
  tools/            # 可选
  assets/           # 可选
```

`SKILL.md` 最小结构：

```markdown
---
name: skill-name
description: 做什么 + 什么时候用（含触发词/报错/场景）
---

# 标题

## Purpose
...

## <主题>
触发词：...
规则：...
```

`name` 与目录名一致；`description` 写清触发场景。

---

## 维护

- 触发词重叠 → **合并**进同一项目内已有 Skill
- `SKILL.md` 保持精简；大块内容放 `references/`
- 发现错误或过时 → 修正或删除
- 新增 Skill 后更新**当前项目** `AGENTS.md`
