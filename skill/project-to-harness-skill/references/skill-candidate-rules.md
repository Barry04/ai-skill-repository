# Knowledge Discovery & Candidate Rules

## 优先发现（工程知识）

按扫描优先级排列：

| 域 | 典型证据 |
|----|----------|
| 数据库规范 | ORM 配置、迁移工具、`schema/`、SQL 风格指南 |
| 数据迁移规范 | Flyway/Liquibase、手工迁移脚本说明 |
| 部署规范 | Dockerfile 旁 README、部署文档（只读摘录） |
| 运维规范 | RUNBOOK、`docs/ops/` |
| CI/CD 规范 | `.github/workflows`、Jenkinsfile（流程描述，不改文件） |
| MQ 规范 | Kafka/Rabbit/Rocket 配置与消费约定 |
| Redis 规范 | 缓存 key、TTL、集群说明 |
| Kafka 规范 | topic、消费组、重试、DLQ |
| 达梦数据库规范 | DM 驱动、方言、兼容说明 |
| Oracle 迁移规范 | 双库、迁移 checklist |
| MyBatis 规范 | 分页插件、日志、XML 组织 |
| Spring 工程规范 | 包结构、配置 profile、启动约定 |
| 排障经验 | troubleshooting、已知问题列表 |
| 架构约定 | 分层、模块边界、ADR |
| 工程约定 | 分支策略、提交规范 |
| 安全规范 | 鉴权、脱敏、依赖扫描说明 |
| 代码组织规范 | 目录约定、模块划分 |

## 准入信号（进入资格化 Phase 2.5）

满足 ≥1 条才可成为候选（仍须评分）：

- 多处重复（≥2 模块/文件）
- 跨模块复用
- README / ADR 明示
- Issue/排障文档反复出现
- 部署/CI 流程依赖
- 中间件配置在多服务一致

## 禁止生成 Skill（仅 conventions.md 或丢弃）

| 类型 | 示例 |
|------|------|
| Controller | 任意 HTTP 控制器 |
| Service | 业务服务类 |
| Entity / DTO | 领域模型、传输对象 |
| 单个 API | 一个 endpoint 的行为 |
| 单个 CRUD | 一张表的增删改查 |
| 单个业务模块 | 订单域、支付域全流程 |
| 单个业务流程 | 状态机、审批流 |
| 单次缺陷修复 | 一次性 hotfix 说明 |
| 单个功能实现 | 某一特性的实现细节 |

这些条目可记入 `knowledge-index.md` 供人读，**不得**进入 `skills/`。

## 与资格化的关系

1. Discovery 列出候选
2. 禁止类直接标 `convention-only` 或 `discard`，不进入评分
3. 其余候选进入 Phase 2.5 打分
4. Merge 后再最终决定是否 Generate
