# ai-skill-repository — Agent 入口

仓库：<https://github.com/Barry04/ai-skill-repository> · 协议：**evolving-skill**

个人 Skill 库：**不在仓库里的经验，对 Agent 不存在。**

> 设计参考：[Harness Engineering](https://github.com/deusyu/harness-engineering) — 人类掌舵，智能体执行；约束写在仓库里，用地图指路而非堆一本手册。

## 三步

1. 从下表选最多 **2** 个相关 Skill，读其 `SKILL.md`
2. 按 Skill 执行任务；长细节在 `references/`，脚本在 `tools/`
3. 发现可复用经验 → **先问用户**，同意后再写入（规则见 `skill/evolving-skill/SKILL.md`）

## Skill 索引

| Skill | 路径 | 何时用 |
|-------|------|--------|
| evolving-skill | `skill/evolving-skill/SKILL.md` | 使用或演进本仓库（首次必读） |
| java-backend-troubleshooting | `skill/java-backend-troubleshooting/SKILL.md` | Java / Spring / MyBatis 排错 |
| linux-test-executor | `skill/linux-test-executor/SKILL.md` | 远程 Linux 测试、SSH 部署验证 |
| project-to-harness-skill | `skill/project-to-harness-skill/SKILL.md` | 任意项目 → Harness 文档 + `skills/`（资格化、登记、preview-first） |

新增 Skill 后更新本表。

## 文件布局

```text
AGENTS.md          ← 你在这里（地图）
README.md          ← 人类总览（中文）
README.en.md       ← English overview
UPGRADE.md         ← 新增/合并 Skill 的维护约定
skill/
  <name>/SKILL.md  ← 每个 Skill 一份，自包含可执行规则
```

## 原则

| 原则 | 做法 |
|------|------|
| 地图非手册 | 入口保持短小；细节下沉到各 Skill |
| 渐进披露 | 先索引 → 再 `SKILL.md` → 按需 `references/` |
| 用户确认才写 | 禁止静默新建或修改 Skill |
| 收熵 | 触发词重叠则合并；过时则删 |

## 安装

将 `evolving-skill` 协议装到本机 Cursor / Claude Skills 目录：

```powershell
.\scripts\install-skill.ps1
```
