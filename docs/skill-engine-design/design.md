# Skill Engine 设计文档（本地版）

## 1. 背景与目标

在日常协作中，Agent 经常遇到三个问题：

- 相同上下文反复输入，成本高；
- 历史经验难以复用，回答一致性差；
- 项目约定无法持续沉淀到后续任务。

本设计的目标是：在**仅本地运行**前提下，实现一个轻量 Skill Engine，让 Agent 能读取项目经验、按需注入、并可在用户确认后写回更新。

---

## 2. 范围与非目标

### 2.1 范围

- 单机、本地文件驱动；
- Skill 存储在仓库根目录 `.project-skill.json`；
- 通过统一安装器接入多工具，避免用户手工分工具配置；
- 支持基本生命周期：创建、使用、更新、演进、淘汰。

### 2.2 非目标

- 不做数据库、缓存、消息队列；
- 不做 HTTP 服务化 API；
- 不做向量数据库和复杂语义检索；
- 不做跨项目集中式管理。

---

## 3. 总体架构

```text
用户输入
  ↓
读取 .project-skill.json
  ↓
关键词匹配 + 评分排序
  ↓
选择 Top 1~3 注入 Prompt
  ↓
任务结束（可选反馈）
  ↓
按策略更新并写回 .project-skill.json
```

组件职责：

- `Skill Store`：本地 JSON 读写；
- `Skill Matcher`：关键词匹配与评分；
- `Skill Selector`：冲突过滤 + TopN 选择；
- `Skill Updater`：根据结果调整 `weight/confidence/status`。

---

## 4. 数据模型

## 4.1 文件结构

使用现有 schema：`schema/project-skill.schema.json`。

```json
{
  "$schema": "./schema/project-skill.schema.json",
  "version": 1,
  "updated_at": "2026-04-27T00:00:00Z",
  "skills": [
    {
      "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "content": "Controller 只做校验和编排，业务逻辑放到 service。",
      "scope": "project:evolving-skill",
      "trigger": ["controller", "service", "分层"],
      "weight": 3,
      "confidence": 0.8,
      "status": "active",
      "created_at": "2026-04-01T08:00:00Z",
      "last_used_at": "2026-04-20T10:00:00Z"
    }
  ]
}
```

## 4.2 关键字段语义

- `id`：稳定标识，用于更新与淘汰；
- `content`：一句话可执行规则；
- `scope`：规则适用范围（项目/路径）；
- `trigger`：匹配关键词集合；
- `weight`：使用频次权重；
- `confidence`：规则质量评分（0~1）；
- `status`：`active | evolving | deprecated`；
- `last_used_at`：用于衰减判断；
- 根级 `updated_at`：文件最后更新时间。

## 4.3 存放路径约定（强约定）

`project-skill.json` 是项目资产，统一使用以下路径规则：

1. 主路径：`<repo>/.project-skill.json`（默认、唯一事实来源）；
2. 初始化模板：`<repo>/.project-skill.example.json`（仅用于首次生成）；
3. 若主路径不存在，适配层应自动创建主路径文件（见 5.1）。

说明：不按工具目录分散存放（如不放在 `.cursor/`、`~/.claude/` 作为数据源），工具目录只放适配配置。

---

## 5. 运行流程

## 5.1 读取阶段

1. 先确定 `repoRoot`（当前项目根目录）；
2. 只允许读取 `<repoRoot>/.project-skill.json`；
3. 禁止从工具目录读取/创建主数据文件（如 `.cursor/`、`~/.claude/`）；
4. 若主文件不存在，则执行初始化：
   - 优先复制 `<repo>/.project-skill.example.json`；
   - 若示例也不存在，则创建最小空文件：

```json
{
  "$schema": "./schema/project-skill.schema.json",
  "version": 1,
  "updated_at": "1970-01-01T00:00:00Z",
  "skills": []
}
```

5. 对已加载内容做格式校验（可选按 schema 校验）；
6. 过滤掉 `status=deprecated` 的条目。

## 5.2 匹配阶段

1. 从用户输入提取关键词（分词或简单切词）；
2. 计算每条 Skill 分数：

```text
score = hit_count * confidence * (1 + weight/10)
```

3. 按 `score` 降序；
4. 对同主题冲突条目做互斥处理（见 5.3）。

## 5.3 选择阶段

- 默认选择 Top 1~3；
- 若两条结论明显冲突，只保留得分更高者；
- `status=evolving` 允许参与排序，但不应与其冲突旧条目同时注入；
- 不相关条目不注入，避免 token 膨胀。

## 5.4 注入阶段

推荐注入格式：

```text
[项目经验]
1) <skill-content>
   - 触发原因: <命中关键词>
   - 置信度: <confidence>
2) ...
```

---

## 6. 生成与去重策略

## 6.1 何时生成新 Skill

仅在以下条件满足时生成：

- 有明确问题与可复用方案；
- 不是一次性临时操作；
- 对未来类似任务有指导价值；
- 用户明确要求“沉淀约定/记录经验”。

## 6.2 去重与演进

- 内容高度相似且触发词重叠：更新旧条目；
- 主题接近但方案不同：新建条目并将相关条目标记为 `evolving`；
- 完全不同：创建新条目。

---

## 7. 生命周期与反馈

生命周期：

```text
create -> use -> evaluate -> update -> evolve/deprecate
```

更新建议：

- 命中并有效：`weight +1`，`confidence` 小幅上调（如 `+0.02`，上限 1）；
- 命中但效果差：`confidence` 下调（如 `-0.05`，下限 0）；
- 长期未命中（按时间窗口判定）：可逐步衰减 `weight`；
- 当 `confidence < 阈值` 且长期低命中：标记 `deprecated`。

---

## 8. 写回策略

写回遵循“谨慎更新”：

- 仅在用户明确同意沉淀/更新时写回；
- 写回前保持字段完整，不破坏 schema；
- 写回后更新根级 `updated_at`（UTC ISO 8601）；
- 禁止写入密钥、token、隐私数据；
- 建议通过 Git 追踪每次变更。

---

## 9. 本地函数边界（不服务化）

```text
loadSkills(path)
validateSkills(json)
matchSkills(input, skills)
selectSkills(candidates, topN=3)
injectSkills(selected)
updateSkills(selected, feedback)
saveSkills(path, json)
```

说明：这是逻辑边界，不要求拆独立进程或 API。

---

## 9.1 统一安装入口

用户只执行一条命令：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-skill.ps1
```

安装器负责：

- 确保 `<repo>/.project-skill.json` 存在（按初始化规则创建）；
- 将同一份 Skill 安装到可用工具目录（如 Cursor/Claude）；
- 屏蔽工具差异，不要求用户手工复制配置文件。

---

## 10. MVP（首版落地）

必做：

- 本地 JSON 读写；
- 关键词匹配 + 评分排序；
- Top 1~3 注入；
- 基础冲突过滤；
- 手动反馈后更新 `weight/confidence`。

可选（第二阶段）：

- 自动衰减；
- 更稳健的关键词提取；
- 按 `scope` 进行路径级隔离。

---

## 11. 风险与控制

- **Skill 污染**：低质量规则增多  
  控制：严格生成门槛 + 低置信淘汰。

- **冲突注入**：多条规则相互矛盾  
  控制：同主题互斥 + 仅保留最高分。

- **上下文膨胀**：注入过多  
  控制：TopN 限制 + 仅注入相关条目。

---

## 12. 目录建议（最小）

```text
docs/skill-engine-design/design.md
schema/project-skill.schema.json
.project-skill.json
scripts/install-skill.ps1
skill/agent-integration.md
integrations/cursor/project-skill.mdc  # 可选：Cursor 兼容层
```

说明：核心协议只依赖 `.project-skill.json` 与 schema，不绑定任何特定 Agent 目录。

---

## 13. 结论

该方案坚持“本地优先、规则优先、质量优先”：

- 先把可复用经验稳定沉淀为结构化 JSON；
- 再通过轻量匹配保证命中质量；
- 最后通过小步更新持续改进。

在这个阶段，不需要数据库，也不需要复杂服务化设计。
