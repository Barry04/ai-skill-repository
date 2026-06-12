# Phase 2.5 — Skill Qualification

## 评分维度

| 维度 | 范围 | 含义 |
|------|------|------|
| **Reusable** | 0–5 | 未来任务重复用到的可能性 |
| **Engineering Value** | 0–5 | 对构建/部署/排障/协作的直接帮助 |
| **Cross Module Usage** | 0–5 | 跨模块/跨服务复用程度 |
| **Evidence Strength** | 0–5 | README、ADR、CI、多文件交叉印证 |
| **Business Specificity** | -5–0 | 业务绑定越深分数越低（0=通用工程，-5=纯业务） |

**总分** = R + E + X + S + B → **-5 ~ 20**

## 决策规则

| 总分 | 动作 |
|------|------|
| **≥ 12** | **Generate Skill** → `skills/<name>/SKILL.md` |
| **6 – 11** | **Move to conventions.md**（标注来源与分数） |
| **< 6** | **Discard**（记入 skill-registry，`status=discarded`） |

## Skill Qualification Table（预览格式）

```markdown
| ID | 摘要 | R | E | X | S | B | 总分 | 决策 | 目标 |
|----|------|---|---|---|---|---|------|------|------|
| Q01 | Kafka 消费组与重试约定 | 4 | 4 | 3 | 4 | -1 | 14 | generate | skills/kafka |
| Q02 | 订单创建流程 | 1 | 1 | 0 | 2 | -5 | -1 | discard | — |
| Q03 | 日志格式约定 | 3 | 2 | 2 | 2 | 0 | 9 | convention | conventions.md |
```

## 评分提示

- 数据库规范、CI/CD、MyBatis/Kafka/Redis 等多为 R、E 偏高
- 仅有单模块 README 一句 → Evidence 最高 2
- 名称含业务实体（Order、Payment）→ Business Specificity ≤ -3
- 合并后对一个 **域** 评一次分，不对每个子话题单独建 Skill
