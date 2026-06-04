# ai-skill-repository

这是一个面向 AI Agent 的个人 Skill 仓库。

根目录放仓库级说明和升级维护说明；`skill/` 目录下每个子目录都是一个独立 Skill。

本仓库约定使用小写 `skill/` 作为 Skill 目录名。

## 仓库结构

```text
README.md                         # 英文使用说明
readme_zh.md                      # 中文使用说明
UPGRADE.md                        # 升级和维护说明
LICENSE
skill/
  evolving-skill/
    SKILL.md
  java-backend-troubleshooting/
    SKILL.md
  linux-test-executor/
    SKILL.md
    references/
    tools/
    assets/
    agents/
```

## Agent 如何使用这个仓库

1. 先阅读仓库级说明，理解这个 Skill 仓库的组织方式。
2. 阅读 `skill/evolving-skill/SKILL.md`，了解 Skill 检索、注入、保存提示和生命周期规则。
3. 从 `skill/<skill-name>/SKILL.md` 中选择和当前任务最相关的 Skill。
4. 每次任务最多使用 2 个高相关 Skill 作为工作上下文。
5. 如果在对话或运行过程中发现可复用经验，先询问用户，再保存为新的 Skill 或合并到已有 Skill。

## 当前 Skill

### evolving-skill

定义 Agent 如何使用和演进这个个人 Skill 仓库。

路径：`skill/evolving-skill/SKILL.md`

### java-backend-troubleshooting

保存 Java 后端常见问题的排查经验，例如 Spring 事务不回滚、MyBatis 分页失效。

路径：`skill/java-backend-troubleshooting/SKILL.md`

### linux-test-executor

支持 Agent 上传文件到 Linux 测试机、执行远程命令、收集日志，并返回结构化测试结果。

路径：`skill/linux-test-executor/SKILL.md`

## 新增或更新 Skill

维护规则见 `UPGRADE.md`。

新增 Skill 使用以下结构：

```text
skill/
  skill-name/
    SKILL.md
```

按需增加可选目录：

```text
references/   # 较长的参考文档，按需读取
tools/        # 可重复执行的脚本或辅助工具
assets/       # 模板、示例、配置样例
agents/       # Agent 展示或发现用元数据
```

## 保存提示规则

Agent 不能静默写入新 Skill。

当发现值得沉淀的经验时，应询问用户：

```text
这条经验以后可能还会用到：<one-line summary>。
要不要我把它沉淀到项目 skill 里？
```

只有用户同意后，才能保存。

## 不应保存的内容

- 密码、token、私钥、凭证。
- 敏感生产环境信息。
- 长日志、大段上下文。
- 当前对话的一次性偏好。
- 未验证的猜测。

## 核心理念

这不是知识库，不是 RAG 系统，也不是平台。

它是一个基于文件的个人 Skill 仓库：足够小，方便检查；足够结构化，可以让 Agent 随着使用逐渐变得更懂你的项目和习惯。
