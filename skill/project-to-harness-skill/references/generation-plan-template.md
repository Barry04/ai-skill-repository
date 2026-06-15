# 生成计划模板

写入前必须完整展示：

```text
=== project-to-harness-skill | <项目名> | preview ===

场景：<新项目 | 进行中 | 历史 | 开源>
范围：<docs-only | docs+skills>
源码 / 构建 / 部署配置：不修改

Phase 1 — Harness Docs
  [ ] AGENTS.md（≤60行）  已有：□覆盖 □合并 □跳过
  [ ] docs/harness/README.md
  [ ] docs/harness/architecture.md
  [ ] docs/harness/commands.md
  [ ] docs/harness/conventions.md

Phase 2 — knowledge-index.md：共 <N> 条

Phase 2.5 — Qualification
  生成 Skill： <M>  |  conventions： <C>  |  丢弃： <D>
  （附 Qualification Table 摘要）

Phase 3 — Skills（含 Merge）
  [ ] skills/kafka/SKILL.md          ← merge: topic, consumer, producer
  [ ] skills/architecture/SKILL.md
  [ ] skills/project-specific/SKILL.md
  ...

Phase 4 — skill-registry.md

Phase 5 — evolving-skill 衔接：□提示后续沉淀到项目 skill/ □跳过

[已验证] <a>  |  [推断] <b>  |  待核对 <c>

回复：全部写入 / 仅 Docs / 自定义 / 取消
```
