# ai-skill-repository

[English](README.en.md) · [GitHub](https://github.com/Barry04/ai-skill-repository)

基于 **evolving-skill** 协议的个人 Harness Skill 仓库——从对话与实践中学习，为 AI Agent 沉淀可复用的工程经验，可版本管理、可演进、可接到任意项目。

设计参考 [Harness Engineering](https://github.com/deusyu/harness-engineering)：**人类掌舵，智能体执行**；约束写在仓库里；入口是地图，不是百科全书。

---

## 这是什么

**evolving-skill** 不是知识库，也不是 RAG 平台。它是一个 **Skill 约束面**：

- 经验落在 `skill/<name>/SKILL.md`，而不是聊天记录里
- Agent 按需读取，每次任务最多选 2 个高相关 Skill
- 新经验须**用户确认**后才写入，禁止静默沉淀

同时提供 **project-to-harness-skill**，把任意代码库（新建 / 进行中 / 历史 / 开源）引导为 Harness 结构：`AGENTS.md`、`docs/harness/`、项目级 `skills/`。

---

## 克隆与安装

```bash
git clone https://github.com/Barry04/ai-skill-repository.git
cd ai-skill-repository
```

安装本仓库 **evolving-skill** 协议到 Cursor / Claude（可选）：

```powershell
.\scripts\install-skill.ps1
```

---

## 两层结构

```text
┌─────────────────────────────────────────────────────────────┐
│  ai-skill-repository（本仓库）                               │
│  evolving-skill 协议 · skill/<name>/SKILL.md                 │
│  日常任务后的增量演进                                         │
└───────────────────────────┬─────────────────────────────────┘
                            │ 可选 handoff
┌───────────────────────────▼─────────────────────────────────┐
│  目标项目                                                    │
│  project-to-harness-skill 批量生成：                           │
│    AGENTS.md + docs/harness/ + skills/                       │
└─────────────────────────────────────────────────────────────┘
```

| 层级 | 位置 | 作用 |
|------|------|------|
| 个人库 | 本仓库 `skill/` | 跨项目复用的排错、部署、约定等 |
| 项目 Harness | 目标仓库 `docs/harness/` + `skills/` | 随项目 Git 管理的地图与 Skill |

---

## 一句话

```
以前：经验在脑子里或对话里 → Agent 每次从零猜
现在：skill/<name>/SKILL.md 在仓库里 → 按需读取，确认后再沉淀
```

---

## 目录结构

```text
AGENTS.md              # Agent 入口（地图 + Skill 索引）
README.md              # 本文件
README.en.md           # English
UPGRADE.md
LICENSE
scripts/install-skill.ps1
skill/
  evolving-skill/
  project-to-harness-skill/
  java-backend-troubleshooting/
  linux-test-executor/
```

**渐进披露：** `AGENTS.md` → `skill/<name>/SKILL.md` → `references/` / `tools/`。

---

## 快速开始

### Agent

1. 读 [AGENTS.md](AGENTS.md)，选最多 **2** 个 Skill
2. 读 `skill/<name>/SKILL.md` 执行任务
3. 可复用经验 → 先问用户（[evolving-skill](skill/evolving-skill/SKILL.md)）

### 为项目做 Harness 化

[project-to-harness-skill](skill/project-to-harness-skill/SKILL.md)：Phase 0–5，默认先预览后写入。维护规则见 [UPGRADE.md](UPGRADE.md)。

---

## 当前 Skill

| Skill | 路径 | 何时用 |
|-------|------|--------|
| evolving-skill | [skill/evolving-skill/SKILL.md](skill/evolving-skill/SKILL.md) | 使用或演进本仓库 |
| project-to-harness-skill | [skill/project-to-harness-skill/SKILL.md](skill/project-to-harness-skill/SKILL.md) | 任意项目 → Harness 文档 + `skills/` |
| java-backend-troubleshooting | [skill/java-backend-troubleshooting/SKILL.md](skill/java-backend-troubleshooting/SKILL.md) | Spring / MyBatis 排错 |
| linux-test-executor | [skill/linux-test-executor/SKILL.md](skill/linux-test-executor/SKILL.md) | 远程 Linux 测试 |

---

## 工作闭环

```text
项目 → project-to-harness-skill → 日常开发 → evolving-skill 增量沉淀 → 可选 handoff
```

---

## 设计原则

| 原则 | 做法 |
|------|------|
| 仓库即记录系统 | 不在仓库里的，Agent 不能稳定依赖 |
| 地图非手册 | 目标项目 `AGENTS.md` ≤60 行 |
| 先预览后写入 | Bootstrap 须用户批准 |
| Skill 即知识单元 | 短、可执行、触发词清晰 |
| 收熵 | 合并重叠，删除过时 |

---

## 许可证

[MIT](LICENSE)
