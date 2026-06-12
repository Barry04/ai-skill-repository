# Integration with evolving-skill

## 职责划分

```text
project-to-harness-skill          evolving-skill
─────────────────────────         ─────────────────────────
Project                           Initial Skills
  ↓                                 ↓
Initial Harness Docs              Continuous Knowledge Evolution
  ↓                                 ↓
Initial Harness Skills    ────→    跨项目沉淀、合并、收熵
```

| | project-to-harness-skill | evolving-skill |
|--|--------------------------|----------------|
| 时机 | 项目接入 / 周期性全量刷新 | 日常任务后增量 |
| 输出 | `<project>/docs/harness/` + `skills/` | `~/evolving-skill/skill/` |
| 写入 | 生成计划一次性确认 | 每条经验单独确认 |
| 登记 | `skill-registry.md` | `AGENTS.md` 个人索引 |

## 闭环

```text
Project
  → project-to-harness-skill（Phase 0–4）
  → Harness Docs + Harness Skills
  → evolving-skill（Phase 5 Handoff，用户确认）
  → Continuous Evolution
  → （可选）验证后回流项目 skills/
```

## Phase 5 Handoff 清单

写入完成后，向用户展示（不自动执行）：

```text
以下 Skills 可考虑同步到 evolving-skill 个人库：
- skills/mybatis/     理由：多项目复用
- skills/troubleshooting/  理由：通用排障模式

是否 handoff？可选：复制 / 合并到已有 skill / 暂不
```

**禁止**自动写入个人库。`skill-registry.md` 的 `Verification State` 为 `[已验证]` 的条目优先推荐 handoff。

## 冲突策略

- 目标项目 `skills/`：**项目特例**优先
- 个人库：通用规则优先
- 同名主题：Agent 在目标项目内读项目 `skills/`，跨项目任务读个人库

## 工具链

- `scripts/install-skill.ps1` 仅安装 **evolving-skill** 协议到 `~/.cursor/skills/`
- **project-to-harness-skill** 随本仓库 `skill/project-to-harness-skill/` 使用，或在目标项目 clone 本仓库作参考
