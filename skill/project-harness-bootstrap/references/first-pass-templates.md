# 第一次生成模板

复制后按项目填空。删除用不到的章节。

---

## AGENTS.md

```markdown
# <项目名> — Agent 入口

> Harness 初稿 | 生成日期：<YYYY-MM-DD> | 业务源码未改动

## 项目是什么

<一句话：领域 + 技术栈>

## 从哪里开始

| 主题 | 路径 | 说明 |
|------|------|------|
| 架构地图 | docs/harness/architecture.md | 模块与分层 |
| 命令 | docs/harness/commands.md | 构建 / 测试 / 运行 |
| 约定 | docs/harness/conventions.md | 编码与目录习惯（多属推断） |
| 人类 README | <path or 无> | |

## 目录速览

| 路径 | 职责 |
|------|------|
| <dir>/ | <职责> |

## 常用命令

见 `docs/harness/commands.md`。优先使用其中已验证命令。

## 约束

- 不在未读 `docs/harness/` 前大规模改架构
- 推断内容以 `conventions.md` 标注为准；有冲突时以代码与测试为准
- 新决策写入 `docs/harness/` 或本文件，避免只留在对话里

## 待核对

- [ ] <item>
```

---

## docs/harness/README.md

```markdown
# Harness 文档

本目录由 **project-harness-bootstrap** 第一次只读扫描生成，未修改业务源码。

| 文件 | 内容 |
|------|------|
| architecture.md | 模块地图 |
| commands.md | 可执行命令 |
| conventions.md | 观察到的约定（推断为主） |

**维护**：验证过的内容把 `[推断]` 改为 `[已验证]`；错误直接改文件，不要堆在聊天里。
```

---

## docs/harness/architecture.md

```markdown
# 架构地图

> 状态：初稿，部分为推断

## 技术栈

- 语言 / 框架：...
- 数据存储：...
- 部署方式：... [推断]

## 模块

```text
<ascii tree>
```

| 模块 | 路径 | 职责 | 置信度 |
|------|------|------|--------|
| ... | ... | ... | 高 / 推断 |

## 请求或调用主路径

1. ...
2. ...

## 已知空白

- ...
```

---

## docs/harness/commands.md

```markdown
# 命令

> 均从项目文件提取；若跑不通请更新本文件。

## 环境要求

- ...

## 构建

```bash
# 来源：<file>
...
```

## 测试

```bash
...
```

## 运行

```bash
...
```

## Lint / 格式化（若有）

```bash
...
```
```

---

## docs/harness/conventions.md

```markdown
# 约定

> 第一次扫描多为 `[推断，待确认]`。确认后改为 `[已验证]`。

## 目录与命名

- [推断] ...

## 分层 / 依赖

- [推断] ...

## 测试

- [推断] ...

## 不要假设

- ...
```
