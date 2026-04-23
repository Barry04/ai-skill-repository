# 项目 Skill 机制设计（动态生成 & 自进化）

## 一、目标

构建一个可动态生成、可积累的项目知识 Skill 机制，使 Agent 能在对话或任务执行过程中：

* 自动沉淀项目经验
* 减少重复上下文输入
* 提升生成结果的准确性与一致性

---

## 二、Skill 定义

Skill 是一条“可复用的项目经验规则”，具备以下特点：

* 可复用（适用于未来类似场景）
* 有指导性（约束 / 推荐 / 事实）
* 可被触发（与用户问题相关）

---

## 三、Skill 数据结构

```json
{
  "content": "分页统一使用 PageHelper",
  "scope": "project:xxx",
  "trigger": ["分页", "page"],
  "weight": 3,
  "confidence": 0.8,
  "status": "active"
}
```

### 字段说明

| 字段         | 说明                                 |
| ---------- | ---------------------------------- |
| content    | Skill 内容（一句话规则）                    |
| scope      | 作用范围（项目级）                          |
| trigger    | 触发关键词                              |
| weight     | 使用权重（命中次数）                         |
| confidence | 置信度                                |
| status     | 状态（active / evolving / deprecated） |

---

## 四、Skill 生命周期

### 1. 创建（Create）

触发条件：

* 明确表达（如“必须 / 统一 / 使用”）
* 多次行为一致（重复使用某种方式）
* 任务总结中产生经验

---

### 2. 成长（Grow）

```text
命中一次 → weight +1
多次一致 → confidence ↑
```

当：

```text
weight ≥ 3 → 升级为强规则
```

---

### 3. 演进（Evolving）

当出现冲突：

```text
旧：分页使用 PageHelper
新：分页使用 MyBatis Plus
```

处理策略：

* 不直接覆盖
* 标记为 evolving
* 新旧规则共存
* 动态调整 confidence

---

### 4. 衰减（Decay）

```text
长期未使用 → weight ↓
confidence ↓
```

---

### 5. 淘汰（Delete）

触发条件：

* 明确废弃
* confidence 过低
* 长期未命中

---

## 五、Skill 生成机制（AI 决策）

### 输入

* 当前对话内容
* 当前已有 Skill

---

### AI 任务

判断：

1. 是否需要生成新的 Skill
2. 是否需要更新已有 Skill
3. 是否需要删除 Skill

---

### 输出格式

```json
{
  "action": "create/update/delete/ignore",
  "reason": "原因说明",
  "confidence": 0.85,
  "skill": {
    "content": "分页使用 MyBatis Plus",
    "trigger": ["分页"]
  }
}
```

---

## 六、生成约束（防止失控）

### 必须满足：

* 可复用（非一次性）
* 可泛化（非具体业务）
* 有指导意义

---

### 禁止生成：

* 临时问题（如“接口慢”）
* 一次性操作
* 无明确规则的描述

---

## 七、Skill 使用机制（运行时）

### 流程

```text
用户输入
↓
关键词提取
↓
匹配 Skill（scope + trigger）
↓
按 weight + confidence 排序
↓
选取 Top 1~3 条
↓
注入 Prompt
```

---

### 注入示例

```text
项目约定：
1. 分页使用 PageHelper
2. Controller 不写业务逻辑
```

---

## 八、Skill 进化机制（核心能力）

### 1. 频次进化

```text
出现次数增加 → weight ↑
```

---

### 2. 趋势识别

```text
旧方案 ↓
新方案 ↑
→ 标记 evolving
```

---

### 3. 自动遗忘

```text
长期未使用 → 自动衰减
```

---

## 九、存储方式

推荐：

```bash
.project-skill.json
```

特点：

* 项目隔离
* 可版本控制
* 可解释

---

## 十、核心设计原则

### 1. 少而精

* 控制 Skill 数量（建议 ≤ 100）
* 只保留高价值规则

---

### 2. 按需注入

* 不全量加载
* 只使用相关 Skill

---

### 3. AI 负责判断，系统负责约束

```text
AI：是否生成 / 更新 / 删除
系统：结构、权重、生命周期控制
```

---

## 十一、整体流程

```text
对话 / 任务执行
↓
AI 判断（Skill 决策）
↓
生成 / 更新 / 删除 Skill
↓
更新权重 & 状态
↓
后续请求自动命中 Skill
```

---

## 十二、总结

该 Skill 机制的本质是：

> 将“对话中的一次性上下文”，转化为“可复用的项目经验规则”

并具备以下能力：

* 可持续积累
* 可动态进化
* 可精准复用

最终目标：

> 让 Agent 从“每次重新理解项目”，进化为“持续参与项目开发”
