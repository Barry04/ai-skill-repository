---
name: evolving-skill
description: >-
  MUST use for this skill repository. How to read, apply, and evolve skills
  in skill/. Ask the user before saving reusable knowledge.
---

# Evolving Skill Harness

本仓库是个人 Skill 库：每个 Skill 是 `skill/<name>/SKILL.md` 里一段**短、可执行**的经验。

Agent 入口地图：`AGENTS.md`（先读索引，再读具体 Skill）。

---

## 使用

任务开始或方向变化时：

1. 对照 `AGENTS.md` 索引，按用户问题、报错、模块名匹配 Skill
2. 最多选 **2** 个高相关 Skill，读其 `SKILL.md`
3. 把规则融入执行，不要大段复制原文
4. 无匹配且任务可重复 → 记下缺口，任务结束时考虑是否新建 Skill

---

## 演进

**核心：可复用经验要提示用户保存，禁止静默写入。**

### 值得保存

- 已验证的 bug 根因 + 修复
- 可重复的构建 / 测试 / 部署命令流
- 框架踩坑（Spring 事务、MyBatis 分页、Docker 网络等）
- 用户明确纠正：「以后都这样」「不要用 X」
- 远程测试机约定（用 `<host>` `<port>` `<user>` 等占位符）

### 不要保存

- 密钥、token、生产主机等敏感信息
- 长日志、未验证猜测、一次性对话偏好
- 读代码就能看出的显而易见信息

### 何时问用户

- 问题已解决或流程已跑通，且经验可复用
- 用户刚纠正了做法
- 任务收尾时，还有未问过用户的沉淀项（同类最多列 **3** 条，不要每步都问）

用户已拒绝的同一条，本会话不再追问。

### 保存话术

```text
💡 可沉淀经验：<一句话摘要>

要保存到 skill/<建议名>/ 吗？
- 新建
- 合并到 <已有 skill>
- 暂不
```

用户同意后再写文件，并告知路径，例如 `skill/java-backend-troubleshooting/SKILL.md`。

---

## Skill 格式

```text
skill/<skill-name>/
  SKILL.md          # 必需
  references/       # 可选，长文档
  tools/            # 可选，可重复脚本
  assets/           # 可选，模板/样例
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

`name` 与目录名一致；`description` 写清触发场景，方便未来匹配。

---

## 维护

- 目的和触发词重叠 → **合并**，不重复建目录
- `SKILL.md` 保持精简；大块内容放 `references/`
- 发现错误或过时 → 修正或删除
- 新增 Skill 后更新根目录 `AGENTS.md` 索引表
