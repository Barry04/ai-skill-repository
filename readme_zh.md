# evolving-skill

面向 AI Agent 的**个人 Skill 仓库**——短小、可读、可演进。

## 一句话

```
传统：经验在脑子里 / 聊天记录里 → Agent 每次从零猜
本仓库：经验写成 skill/<name>/SKILL.md → Agent 按需读取，用户确认后沉淀
```

## 结构

```text
AGENTS.md              # Agent 入口（地图 + Skill 索引）
readme_zh.md           # 本文件
UPGRADE.md             # 维护约定
scripts/install-skill.ps1
skill/
  evolving-skill/      # 如何使用与演进本仓库
  java-backend-troubleshooting/
  linux-test-executor/   # 含 tools/、references/、assets/
```

## Agent 怎么用

1. 读 `AGENTS.md` 找相关 Skill
2. 读对应 `skill/<name>/SKILL.md`（每次最多 2 个）
3. 发现可复用经验 → 先问用户，同意后再保存（详见 `skill/evolving-skill/SKILL.md`）

## 人类怎么维护

见 `UPGRADE.md`：命名、合并、占位符、质量检查。

安装协议到本机 Cursor / Claude：

```powershell
.\scripts\install-skill.ps1
```

## 当前 Skill

| Skill | 说明 |
|-------|------|
| evolving-skill | 检索、沉淀、生命周期 |
| java-backend-troubleshooting | Spring 事务、MyBatis 分页等 |
| linux-test-executor | 远程 SSH 测试与日志收集 |
| project-harness-bootstrap | 旧项目 Harness 化初稿（只读扫描，不改源码） |

## 理念

这不是知识库或 RAG 平台，而是**文件化的个人约束**：

- 仓库里有的，Agent 才能稳定复用
- 入口是地图，不是百科全书
- 沉淀靠用户确认，不靠 Agent 自作主张
