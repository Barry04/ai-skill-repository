---
name: project-harness-bootstrap
description: >-
  Bootstrap Harness-style agent entry for an existing or legacy codebase without
  touching application source on the first pass. Use when migrating an old project
  to harness engineering, generating AGENTS.md and docs/harness/ from read-only
  reconnaissance, or when the user asks to make a repo agent-ready.
---

# Project Harness Bootstrap

为**已有项目**补齐 Harness 工程结构：第一次只做只读了解 + 生成地图类文档，**不修改业务源码**。

参考：[Harness Engineering](https://github.com/deusyu/harness-engineering) — 仓库即记录系统、地图非手册、渐进披露。

---

## 边界（第一次必须遵守）

| 允许 | 禁止 |
|------|------|
| 读文件、列目录、搜配置 | 改 `src/`、`lib/`、`app/` 等业务代码 |
| 新增 `AGENTS.md`、`docs/harness/**` | 改 `pom.xml` / `package.json` / Dockerfile 等构建运行配置 |
| 新增 `.cursor/rules/` 指针类规则（可选，需用户同意） | 删改现有文档或代码 |
| 在回复里给出生成摘要 | 未确认就批量写入 |

业务源码 = 任何直接影响编译、运行、部署的目录与文件。拿不准时**当作禁止修改**。

---

## 流程

### 0. 确认目标

向用户确认：

- 项目根目录路径
- 输出位置（默认：仓库根 `AGENTS.md` + `docs/harness/`）
- 是否允许额外生成 `.cursor/rules/project-harness.mdc`（默认否）

### 1. 只读侦察（约 15–30 分钟量级）

按优先级扫，够用即停：

1. 根目录：`README*`、`LICENSE`、`Makefile`、`docker-compose*`
2. 构建清单：`package.json`、`pom.xml`、`build.gradle*`、`go.mod`、`Cargo.toml`、`pyproject.toml` 等
3. 目录树：顶层 + 主要模块（深度 2–3，忽略 `node_modules`、`.git`、`dist`、`target`、`build`）
4. 入口：main、启动类、路由注册、CLI entry
5. 测试与 CI：`.github/workflows`、`Jenkinsfile`、`*_test.*`、`test/`
6. 已有 Agent 文件：`AGENTS.md`、`CLAUDE.md`、`.cursor/rules/`

记录到工作笔记（不必先写文件）：

- 技术栈与版本（能确定的）
- 模块 / 包与职责（推断，标 `推断`）
- 构建、测试、启动命令（从脚本或文档提取）
- 分层或依赖方向（若有明显模式）
- 空白与风险：缺 README、缺测试、命名混乱等

### 2. 生成 Harness 骨架

遵循 **地图非手册**：入口短，细节进 `docs/harness/`。

默认产出（模板见 `references/first-pass-templates.md`）：

```text
AGENTS.md
docs/harness/
  README.md           # 本目录说明 + 生成日期 + 待人工核对项
  architecture.md     # 模块地图、分层、关键路径
  commands.md         # build / test / run / lint（从项目提取）
  conventions.md      # 已观察到的约定（均标推断，供后续验证）
```

`AGENTS.md` 目标 **≤ 100 行**，只含：项目一句话、Skill/文档索引表、侦察摘要、下一步阅读路径。

`conventions.md` 中每条约定注明：`[已验证]` 或 `[推断，待确认]`。第一次只允许 `[推断]`，除非文档或代码中明确写明。

### 3. 给用户过目再写入

先输出**生成预览**（目录树 + 各文件要点），询问：

```text
已为 <项目名> 准备好 Harness 初稿（未改业务源码）。
写入位置：
- AGENTS.md
- docs/harness/（4 个文件）

是否写入？需要调整哪些章节？
```

用户同意后再创建文件。若已有 `AGENTS.md`，**合并或重命名为 `AGENTS.md.bak` 前必须征得同意**。

### 4. 收尾说明

写入后告知用户：

- 生成了什么、哪些是推断
- 建议人工核对的 3–5 项
- 第二阶段可做啥（linter、`.cursor/rules`、拆 `references/`、与 evolving-skill 联动）— **不在第一次自动做**

---

## 质量自检

- [ ] 未改动业务源码与构建配置
- [ ] `AGENTS.md` ≤ 100 行，是指针不是百科
- [ ] 命令均来自项目内真实文件，非编造
- [ ] 推断内容已标注，无伪装成事实
- [ ] 无密钥、内网地址、账号等敏感信息写入

---

## 触发词

`历史项目`、`老项目`、`harness 化`、`生成 AGENTS.md`、`让 Agent 能读懂这个仓库`、`项目 harness 引导`、`只读扫描`、`agent-ready`
