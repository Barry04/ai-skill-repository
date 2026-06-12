# Skill 模板

符合 Harness / evolving-skill 规范：`name` = 目录名，`description` 含触发词。

```markdown
---
name: <skill-name>
description: >-
  <一句话>. Use when <场景、技术、报错>.
---

# <标题>

> project-to-harness-skill | <YYYY-MM-DD> | 证据：<paths>
> Qualification: <score>/20 | <[已验证]|[推断]>

## Purpose

## 触发词

## 规则

### <章节>（合并域时多章节）

- [已验证] ... — 来源：`path`
- [推断] ...

## 命令（可选）

## 不要假设

## 维护

验证后更新 Verification State；泛化后可 handoff 到 evolving-skill。
```

## 标准 Skill 骨架

- `architecture` — 模块、分层、依赖
- `deployment` — 环境、发布（引用 CI 路径，不改 CI）
- `database` — 通用库表/迁移约定
- `troubleshooting` — 症状 → 诊断 → 处理
- `coding-conventions` — 命名、测试、PR
- `project-specific` — 无法并入标准/技术域的工程知识（多章节）

## 合并域示例（skills/kafka/SKILL.md）

```markdown
## Producer
## Consumer
## Topic 与消费组
## 重试与 DLQ
```
