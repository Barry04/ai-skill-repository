# ai-skill-repository

[English](README.en.md) · [GitHub](https://github.com/Barry04/ai-skill-repository)

面向 AI Agent 的**个人 Skill 库**——把可复用的工程经验写成 `skill/<name>/SKILL.md`，按需读取、确认后沉淀、随使用演进。

设计参考 [Harness Engineering](https://github.com/deusyu/harness-engineering)：**人类掌舵，智能体执行**；约束写在仓库里；入口是地图，不是百科全书。

> **仓库名** `ai-skill-repository` · **内含多个 Skill**，`evolving-skill` 是其中之一（本仓库的使用与演进协议），不是仓库的全部。

---

## 这是什么

本仓库**不是**单一 Skill，也**不是**知识库或 RAG 平台。它是一个可版本管理的 **Skill 集合**：

- 每个 Skill 独立目录：`skill/<name>/SKILL.md`
- Agent 每次任务最多选 **2** 个高相关 Skill
- 新经验须**用户确认**后才写入（规则见 [evolving-skill](skill/evolving-skill/SKILL.md)）
- 运行 `install-skill` 脚本可一次安装**全部** Skill 到 Cursor / Claude

---

## 当前 Skill 一览

### evolving-skill — 本仓库协议

**何时用：** 使用或演进 `ai-skill-repository` 本身时必读。

定义 Skill 如何检索、注入、沉淀与收熵：先问用户再保存、合并重叠 Skill、更新 `AGENTS.md` 索引等。**不负责具体业务排错或部署**，而是管「这个 Skill 库怎么运转」。

→ [skill/evolving-skill/SKILL.md](skill/evolving-skill/SKILL.md)

---

### project-to-harness-skill — 项目 Harness 化

**何时用：** 把任意项目（新建 / 进行中 / 历史 / 开源）变成 Agent 可读结构。

只读扫描 → 知识发现 → 资格化评分 → 生成 `AGENTS.md`、`docs/harness/`、项目级 `skills/`。默认先预览，用户确认后才写入；不改业务源码与构建/部署配置。

→ [skill/project-to-harness-skill/SKILL.md](skill/project-to-harness-skill/SKILL.md)

---

### java-backend-troubleshooting — Java 后端排错

**何时用：** Spring 事务不回滚、MyBatis 分页失效、Java 服务调试等。

沉淀可复用的 Java 后端排查规则，例如 `@Transactional` 代理问题、分页插件未生效等。

→ [skill/java-backend-troubleshooting/SKILL.md](skill/java-backend-troubleshooting/SKILL.md)

---

### linux-test-executor — 远程 Linux 测试

**何时用：** 在 Linux 测试机上验证部署、跑集成测试、收集日志。

支持 SSH 上传文件、执行远程命令、采集日志，附带 `tools/` 脚本（`remote_runner.py` 等）与连接配置样例。

→ [skill/linux-test-executor/SKILL.md](skill/linux-test-executor/SKILL.md)

---

## 它们如何配合

```text
ai-skill-repository（本仓库，多个 Skill）
  │
  ├─ evolving-skill          → 管 Skill 库怎么读、怎么存
  ├─ project-to-harness-skill → 把目标项目变成 Harness 结构
  ├─ java-backend-troubleshooting → 日常 Java 排错
  └─ linux-test-executor     → 远程测试验证

目标项目（由 project-to-harness-skill 生成）
  └─ AGENTS.md + docs/harness/ + skills/
       ↓ 日常开发中沉淀的经验
  └─ evolving-skill 协议 → 回写到本仓库 skill/（用户确认后）
```

---

## 克隆与安装

```bash
git clone https://github.com/Barry04/ai-skill-repository.git
cd ai-skill-repository
```

安装**全部** Skill 到 Cursor / Claude：

| 平台 | 命令 |
|------|------|
| Windows | `.\scripts\install-skill.ps1` |
| macOS / Linux | `bash scripts/install-skill.sh` |

`AGENTS.md` 留在仓库内作索引；建议将本仓库加入工作区或符号链接，便于 Agent 发现全部 Skill。

---

## 目录结构

```text
AGENTS.md              # Agent 入口（Skill 索引）
README.md              # 本文件
README.en.md
UPGRADE.md
scripts/install-skill.ps1 | .sh
skill/
  evolving-skill/
  project-to-harness-skill/
  java-backend-troubleshooting/
  linux-test-executor/         # 含 references/、tools/、assets/
```

**渐进披露：** `AGENTS.md` → `skill/<name>/SKILL.md` → `references/` / `tools/`。

---

## 快速开始

**Agent：** 读 [AGENTS.md](AGENTS.md) → 选 Skill → 执行 → 可复用经验先问用户。

**人类：** 新增或合并 Skill 见 [UPGRADE.md](UPGRADE.md)。

---

## 设计原则

| 原则 | 做法 |
|------|------|
| 仓库即记录系统 | 不在仓库里的，Agent 不能稳定依赖 |
| 地图非手册 | 入口短；细节在各 `SKILL.md` |
| 先预览后写入 | Harness 化与沉淀须用户批准 |
| Skill 即知识单元 | 短、可执行、触发词清晰 |
| 收熵 | 合并重叠，删除过时 |

---

## 许可证

[MIT](LICENSE)
