# Skill Merge Detection

避免碎片化 Skill。同**知识域**自动合并为一个 `skills/<domain>/SKILL.md`，用多章节组织。

## 原则

1. **一个技术域一个 Skill**（Kafka、MyBatis、达梦、Redis…）
2. 子话题作 `##` 章节，不建子目录 Skill
3. 合并后在 skill-registry 记录 `Merge From`
4. 合并后重新算资格分（通常 Evidence、Cross Module 上升）

## 合并示例

| 碎片候选 | 合并为 |
|----------|--------|
| kafka-producer, kafka-consumer, kafka-topic | `skills/kafka/` |
| mysql-pagination, mysql-index | `skills/database/` 或 `skills/database-mysql/` |
| dm8-pagination, dm8-index, dm8-compat | `skills/database-dm8/` |
| mybatis-log, mybatis-pagination, mybatis-style | `skills/mybatis/` |
| redis-cache, redis-key-prefix | `skills/redis/` |

## 命名优先级

1. 标准域：`architecture`、`deployment`、`database`、`troubleshooting`、`coding-conventions`
2. 技术域：`kafka`、`mybatis`、`redis`、`database-dm8`、`database-oracle-migration`
3. 仍无法归类且总分 ≥12：`project-specific`（单文件多章节，不再拆）

## 禁止合并

- 业务模块 A + 业务模块 B → 不合并为 Skill，进 `conventions.md` 或丢弃
- 无共同证据来源的无关技术 → 保持独立 Skill

## 检测启发

- 共享前缀：`kafka-*`、`mybatis-*`、`dm8-*`
- 同一配置文件：`application.yml` 同一 block
- 同一 README 章节下的多条约定
