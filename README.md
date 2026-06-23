# ai-skill-repository

[English](README.en.md) · [GitHub](https://github.com/Barry04/ai-skill-repository)

面向 AI Agent 的**个人 Skill 库**——把可复用的工程经验写成 `skill/<name>/SKILL.md`，按需读取、确认后沉淀、随使用演进。

设计参考 [Harness Engineering](https://github.com/deusyu/harness-engineering)：**人类掌舵，智能体执行**；约束写在仓库里；入口是地图，不是百科全书。

> **仓库名** `ai-skill-repository` · 内含多个可全局安装的 Skill；**evolving-skill** 是演进协议，日常沉淀写在**各项目**的 `skill/` 目录。

---

## 这是什么

本仓库**不是**单一 Skill，也**不是**知识库或 RAG 平台。它是一个可版本管理的 **Skill 集合**：

- 每个 Skill 独立目录：`skill/<name>/SKILL.md`
- Agent 每次任务最多选 **2** 个高相关 Skill
- 新经验须**用户确认**后才写入（规则见 [evolving-skill](skill/evolving-skill/SKILL.md)）
- 运行 `install.ps1` / `install.sh` 可一次安装**全部** Skill 到 Cursor / Claude

---

## 当前 Skill 一览

### evolving-skill — 演进协议（装全局，写项目）

**何时用：** 任何项目里需要沉淀、合并、演进 Skill 时。

- **协议本身** → 安装到 `~/.cursor/skills/`、`~/.claude/skills/`（跨项目）
- **生成 / 演化的 Skill** → 写在**当前项目** `skill/<name>/`，并更新项目 `AGENTS.md`

不负责具体业务排错，而是管「怎么发现经验、怎么问用户、怎么落到项目里」。

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
全局（install.ps1 / install.sh 安装到 ~/.cursor/skills 等）
  ├─ evolving-skill              → 演进协议
  ├─ project-to-harness-skill  → 项目 Harness 化
  ├─ java-backend-troubleshooting
  └─ linux-test-executor

目标项目（随项目 Git）
  ├─ docs/harness/ + skills/   → project-to-harness-skill 批量生成（可选）
  └─ skill/                    → evolving-skill 日常沉淀（用户确认后写入）
```

---

## 克隆与安装

```bash
git clone https://github.com/Barry04/ai-skill-repository.git
cd ai-skill-repository
```

安装**全部** Skill 到 Cursor / Claude：

| 平台 | 命令（在仓库根目录或解压后的包根目录执行） |
|------|------|
| Windows | `.\install.ps1` |
| macOS / Linux | `bash install.sh` |

脚本默认从**自身所在目录**读取 `skill/`，解压后直接执行即可，无需传路径。

`AGENTS.md` 留在仓库内作索引；建议将本仓库加入工作区或符号链接，便于 Agent 发现全部 Skill。

### GitHub Actions 自动打包与安装验证

推送 `skill/` 或安装脚本变更到 `master` 时，[package-and-install-skills](.github/workflows/package-and-install-skills.yml) 流水线会：

1. **分别打包** — Windows 包：`skill/` + `install.ps1`；macOS 包：`skill/` + `install.sh`（无 `scripts/` 目录）
2. **Windows** — 解压后执行 `.\install.ps1`，安装到 `%USERPROFILE%\.cursor\skills` 与 `%USERPROFILE%\.claude\skills`
3. **macOS** — 解压后执行 `bash install.sh`，安装到 `~/.cursor/skills` 与 `~/.claude/skills`

在 GitHub **Actions** 页下载对应平台 Artifact，解压后在包根目录执行：

| 平台 | 命令 |
|------|------|
| Windows | `.\install.ps1` |
| macOS | `bash install.sh` |

也可在 Actions 页手动 **Run workflow** 触发。

---

## 目录结构

```text
AGENTS.md              # Agent 入口（Skill 索引）
README.md              # 本文件
README.en.md
UPGRADE.md
LICENSE
install.ps1
install.sh
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

## 触发率维护

Skill 触发率低时，优先检查：

1. `AGENTS.md` 是否明确要求任务开始先读索引。
2. `AGENTS.md` 是否列出该 Skill 的路径和“何时用”。
3. `SKILL.md` frontmatter `description` 是否包含中英文任务说法、常见报错、工具/框架名。
4. 触发词是否只写在正文里；只写正文通常不够。
5. 空目录或缺 `SKILL.md` 的 Skill 不会稳定触发。

---

## 许可证

[MIT](LICENSE)
