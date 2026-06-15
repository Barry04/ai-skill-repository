---
name: project-to-harness-skill
description: >-
  Project → Harness Skill Generator for new, in-progress, legacy, or open-source
  repos. Read-only discovery, knowledge qualification, harness docs, and skills/
  generation with preview-first. Use for harness init, AGENTS.md, skill extraction,
  GitHub project analysis, or project-to-harness-skill workflow.
---

# Project → Harness Skill Generator

**任何项目**（新建 / 进行中 / 历史 / 开源）→ 理解 → 提取工程知识 → 资格化筛选 → Harness 文档 → Harness Skills。

参考：[Harness Engineering](https://github.com/deusyu/harness-engineering) — Repository as System of Record、Maps not Manuals、Progressive Disclosure、Preview First、Skill as Reusable Knowledge Unit。

- 流程图：`references/workflow.md`
- 目录结构：`references/output-layout.md`
- evolving-skill 闭环：`references/evolving-skill-integration.md`

---

## 支持场景

| 场景 | 输入 | 产出 |
|------|------|------|
| 新项目初始化 | Spring Boot 等骨架仓库 | AGENTS.md + docs/harness + 初始 skills |
| 进行中项目 | 已有代码与 README | 补齐 Harness 结构 |
| 历史项目接手 | 旧仓库 | 项目地图 + Skill 提取 |
| 开源项目分析 | GitHub 克隆 / 本地路径 | Harness Docs + Skills（只读） |

---

## 铁律

| # | 规则 |
|---|------|
| 1 | **Preview First**：默认只预览；用户批准生成计划后才写入 |
| 2 | 写入前展示**生成计划**（`references/generation-plan-template.md`） |
| 3 | 已有 `AGENTS.md` → **必须询问**覆盖 / 合并 / 跳过 |
| 4 | 知识标注 `[已验证]` 或 `[推断]` |
| 5 | **禁止**改业务源码、`Controller`/`Service`/`Entity` 等应用代码 |
| 6 | **禁止**改构建配置（`pom.xml`、`package.json`、`build.gradle*` 等） |
| 7 | **禁止**改部署配置（`Dockerfile`、`docker-compose*`、K8s、CI 部署步骤） |
| 8 | 只允许**新增** `AGENTS.md`、`docs/harness/**`、`skills/**` |

---

## 六阶段流程

```text
Phase 0  Project Discovery
Phase 1  Harness Bootstrap        → AGENTS.md + docs/harness/*
Phase 2  Knowledge Discovery      → knowledge-index.md
Phase 2.5 Skill Qualification     → skill-registry.md（评分表）
Phase 3  Skill Generation         → skills/*/SKILL.md（含 merge）
Phase 4  Skill Registry Update    → 回写 registry + AGENTS.md 索引
Phase 5  evolving-skill 衔接     → 提示后续沉淀到项目 skill/
```

---

### Phase 0 — Project Discovery

确认：项目根路径、场景（新/进行中/历史/开源）、范围（`docs-only` / `docs+skills`，默认后者）、`preview-only=true`。

只读识别：项目类型、技术栈、成熟度（空仓库 / 活跃 / 陈旧）、是否已有 `AGENTS.md` / `skills/`。

---

### Phase 1 — Harness Bootstrap

扫描：README、`docs/`、构建文件、Docker、CI/CD、顶层结构。模板：`references/harness-doc-templates.md`。

产出预览：

```text
AGENTS.md                    # ≤60 行，仅索引
docs/harness/README.md
docs/harness/architecture.md
docs/harness/commands.md
docs/harness/conventions.md
```

**AGENTS.md 只允许**：项目简介、阅读顺序、Docs 索引、Skills 索引、Agent 入口说明。**禁止**详细知识（细节进 `docs/harness/` 或 `skills/`）。

---

### Phase 2 — Knowledge Discovery

归纳知识条目 → 预览 `docs/harness/knowledge-index.md`。

**优先发现域**（见 `references/skill-candidate-rules.md`）：数据库/迁移、部署、运维、CI/CD、MQ、Redis、Kafka、达梦、Oracle 迁移、MyBatis、Spring 工程、排障、架构、工程约定、安全、代码组织。

**禁止升格为 Skill**（仅进 `conventions.md`）：Controller、Service、Entity、DTO、单个 API/CRUD/业务模块/流程、单次缺陷、单个功能实现。

---

### Phase 2.5 — Skill Qualification

对每个候选评分（`references/skill-qualification.md`）：

| 维度 | 范围 |
|------|------|
| Reusable | 0–5 |
| Engineering Value | 0–5 |
| Cross Module Usage | 0–5 |
| Evidence Strength | 0–5 |
| Business Specificity | -5–0 |

**总分 -5 ~ 20**：≥12 生成 Skill；6–11 写入 `conventions.md`；<6 丢弃。

**Skill Merge Detection**（`references/skill-merge-rules.md`）：同知识域合并，避免 `kafka` / `kafka-topic` / `kafka-consumer` 碎片化。

输出：**Skill Qualification Table** → 写入预览 `docs/harness/skill-registry.md`。

---

### Phase 3 — Skill Generation

按资格化结果与合并规则生成 `skills/*/SKILL.md`。模板：`references/skill-templates.md`。

标准 + 可选目录：

```text
skills/architecture|deployment|database|troubleshooting|coding-conventions/
skills/<merged-domain>/          # 如 kafka、mybatis、database-dm8
skills/project-specific/       # 无法并入标准域的项目特有工程知识
```

---

### Phase 4 — Skill Registry Update

定稿 `docs/harness/skill-registry.md`（字段见 `references/output-layout.md`），更新 `AGENTS.md` Skills 索引（仍 ≤60 行）。

---

### Phase 5 — evolving-skill 衔接

Harness 批量生成完成后，按 `references/evolving-skill-integration.md` 提示：

- 后续日常沉淀使用 **evolving-skill** 协议（全局）
- 新 Skill 写入**本项目** `skill/`，并更新项目 `AGENTS.md`
- 不自动同步到全局 Skill 目录或 `ai-skill-repository`

---

## 质量自检

- [ ] Preview → 用户确认 → 写入
- [ ] `AGENTS.md` ≤ 60 行，无详细知识
- [ ] 业务 / 构建 / 部署配置未改
- [ ] 资格化评分与 merge 已记录于 skill-registry
- [ ] 禁止类知识仅出现在 conventions.md
- [ ] 无敏感信息明文

---

## 触发词

`project-to-harness-skill`、`harness 化`、`生成 AGENTS.md`、`知识提取`、`Skill 生成`、`新项目 harness`、`开源项目分析`、`agent-ready`、`Skill Qualification`、`skill-registry`
