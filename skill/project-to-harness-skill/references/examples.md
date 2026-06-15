# 场景示例

## 1. 新项目（Spring Boot）

**输入**：`spring init` 后的骨架，仅有 `pom.xml` + `Application.java` + 空 README。

**Phase 0**：识别为「新项目、Java/Spring、Harness 空白」。

**Phase 1–4 预览**：

- `AGENTS.md`：简介 + 指向 architecture/commands
- `skills/architecture/`：从包结构推断 `[推断]`
- `skills/deployment/`：若已有 Dockerfile 片段则提取；否则 conventions 记「待补充」
- 无 Kafka/MyBatis → 不生成空 Skill

**用户确认后写入**。

---

## 2. 进行中项目

**输入**：多模块 Maven，有 README、CI、部分 `docs/`。

**Discovery**：MyBatis 分页在 3 个模块 README 重复 → 候选 `mybatis-pagination`、`mybatis-log`。

**Qualification + Merge**：合并为 `skills/mybatis/`，总分 15 → generate。

**Controller 订单 API** → 禁止 Skill，进 `conventions.md` 一行摘要或丢弃。

---

## 3. 历史项目接手

**输入**：5 年旧仓库，无 AGENTS.md，有 `docs/legacy/` 与 Jenkinsfile。

**Bootstrap**：`commands.md` 从 Jenkinsfile **只读**摘录阶段名（不改文件）。

**Registry**：记录每条 Skill 证据为 `Jenkinsfile:12-40` `[已验证]`。

---

## 4. 开源项目（GitHub）

**输入**：克隆 `https://github.com/org/repo`，只读分析。

**约束**：同样 preview-first；不写 fork 除非用户明确要求。

**后续沉淀**：使用 evolving-skill 协议，写入本项目 `skill/`。

---

## 反例：不应出现的产出

```text
skills/order-controller/     ✗ 业务
skills/user-crud/          ✗ 单 CRUD
skills/kafka-topic/        ✗ 应 merge 到 skills/kafka/
skills/kafka-consumer/     ✗
AGENTS.md 含 200 行架构说明  ✗ 超 60 行且含详细知识
```
