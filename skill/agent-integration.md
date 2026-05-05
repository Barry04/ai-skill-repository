# `.project-skill.json` 统一安装与适配说明

## 目标

一个 Skill 适配所有工具，核心协议只保留一套：

- `<repo>/.project-skill.json`
- `<repo>/schema/project-skill.schema.json`

不要求用户按工具手工配置不同流程。

## 原则

- `project-skill.json` 是项目资产，不是工具资产；
- 工具差异由安装器处理，不暴露给用户；
- 用户只执行一条安装命令，后续各工具按同一规则使用数据。

## 存放路径规范（必须）

- 主路径固定：`<repo>/.project-skill.json`
- 示例模板：`<repo>/.project-skill.example.json`
- 禁止在工具目录创建主数据文件（例如 `.cursor/`、`~/.claude/`）

## 缺失文件时的自动初始化（必须）

每次读取前执行：

1. 若 `<repo>/.project-skill.json` 存在，直接读取；
2. 若不存在且 `<repo>/.project-skill.example.json` 存在，复制生成；
3. 若都不存在，创建最小空文件：

```json
{
  "$schema": "./schema/project-skill.schema.json",
  "version": 1,
  "updated_at": "1970-01-01T00:00:00Z",
  "skills": []
}
```

## 统一安装（用户视角）

在项目根目录执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-skill.ps1
```

该命令会自动安装同一个 Skill 到可用工具目录（如 Cursor/Claude），无需手工分工具复制。

## 运行时统一规则

- 读取 `<repo>/.project-skill.json`
- 按 `trigger + weight + confidence` 选择 Top 1~3
- 注入当前会话上下文
- 仅在用户明确要求沉淀/更新时写回
