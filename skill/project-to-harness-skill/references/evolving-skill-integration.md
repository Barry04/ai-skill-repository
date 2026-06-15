# Integration with evolving-skill

## 职责划分

```text
全局（install 安装）
  evolving-skill          → 演进协议（怎么发现、怎么问、怎么写）
  java-backend-troubleshooting、linux-test-executor 等 → 跨项目通用 Skill

当前项目（随 Git）
  skill/<name>/           → evolving-skill 生成 / 演化的 Skill
  AGENTS.md               → 项目 Skill 索引
  docs/harness/           → project-to-harness-skill 生成的文档（可选）
  skills/                 → project-to-harness-skill 批量生成的初始 Skill（可选）
```

| | project-to-harness-skill | evolving-skill |
|--|--------------------------|----------------|
| 安装位置 | 全局 `~/.cursor/skills/` 等 | 全局（协议本身） |
| 产出位置 | 目标项目 `docs/harness/` + `skills/` | 目标项目 **`skill/`** |
| 时机 | 项目接入 / 全量刷新 | 日常任务后增量 |
| 写入 | 生成计划一次性确认 | 每条经验单独确认 |

## 闭环

```text
Project
  → project-to-harness-skill（初始 docs + skills/）
  → 日常开发
  → evolving-skill 协议（全局）指导沉淀
  → 写入项目 skill/ + 更新项目 AGENTS.md
```

**不再**默认 handoff 到 `ai-skill-repository` 或个人全局库。项目经验留在项目里。

## Phase 5（可选提示）

Harness 批量生成完成后，可提示用户：

```text
后续日常沉淀请使用 evolving-skill 协议，保存到本项目的 skill/ 目录。
是否现在根据 skill-registry 在 skill/ 下补建条目？（可选）
```

## 冲突策略

- 项目 `skill/`：**日常演进**的主写入位置
- 项目 `skills/`：harness 批量生成的初始 Skill；与 `skill/` 主题重叠时合并，不重复维护
- 全局 Skill：只读参考（排错、SSH 测试等），不作为项目沉淀目标

## 工具链

- `install.ps1` / `install.sh`：安装**全局** Skill（含 evolving-skill 协议）
- 项目 `skill/`：由 evolving-skill 在工作时创建与维护，**不**通过 install 脚本写入
