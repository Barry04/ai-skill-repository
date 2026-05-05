# Skill Engine 设计文档目录

本目录用于沉淀 Skill Engine 的完整设计文档，建议按以下结构逐步补齐。

## 建议文档结构

- `01-overview.md`：背景、目标、范围、术语
- `02-architecture.md`：整体架构、模块边界、时序
- `03-data-model.md`：`.project-skill.json`、Schema、版本演进
- `04-runtime-matching.md`：触发、检索、排序、注入策略
- `05-lifecycle.md`：create/grow/evolving/decay/delete 规则
- `06-writeback-policy.md`：何时写回、冲突处理、审计
- `07-security-and-governance.md`：隐私、安全、权限与合规
- `08-observability.md`：指标、日志、回放、评估
- `09-testing-and-validation.md`：单测、集成、回归与验收标准
- `10-rollout-plan.md`：灰度、迁移、回滚、里程碑

## 约定

- 文档命名使用数字前缀，保证阅读顺序稳定。
- 每篇文档开头包含：目的、输入、输出、非目标。
- 关键策略建议给出伪代码或流程图，避免仅描述性文字。

