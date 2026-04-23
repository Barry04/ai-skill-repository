# evolving-skill
A self-evolving skill system that learns from conversations and builds reusable project knowledge for AI agents.

# 构建一个可动态生成、可积累的项目知识 Skill 机制，使 Agent 能在对话或任务执行过程中：

* 自动沉淀项目经验
* 减少重复上下文输入
* 提升生成结果的准确性与一致性

## 最小可落地文件

* 数据：根目录 `.project-skill.json`（示例副本：`.project-skill.example.json`）
* Schema：`schema/project-skill.schema.json`
* Cursor：`.cursor/rules/project-skill.mdc` + 说明文档 `skill/cursor-rule-integration.md`
