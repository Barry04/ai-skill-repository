# 输出目录结构

目标项目完整布局（按资格化结果裁剪 `skills/` 子目录）。

```text
<project-root>/
├── AGENTS.md                              # ≤60 行：简介 + 阅读顺序 + 索引 only
├── docs/
│   └── harness/
│       ├── README.md
│       ├── architecture.md
│       ├── commands.md
│       ├── conventions.md                 # 含评分 6–11 的条目 + 禁止类业务知识摘要
│       ├── knowledge-index.md             # Phase 2 全量知识条目
│       └── skill-registry.md              # Phase 2.5/4 资格化与生成登记
└── skills/
    ├── architecture/
    │   └── SKILL.md
    ├── deployment/
    │   └── SKILL.md
    ├── database/
    │   └── SKILL.md
    ├── troubleshooting/
    │   └── SKILL.md
    ├── coding-conventions/
    │   └── SKILL.md
    ├── <merged-domain>/                   # 如 kafka、mybatis、database-dm8
    │   └── SKILL.md
    └── project-specific/
        └── SKILL.md                       # 项目特有、无法并入标准域的工程知识
```

## skill-registry.md 字段

| 列 | 说明 |
|----|------|
| Skill Name | 目录名 / `name` |
| Domain | 知识域 |
| Evidence | 证据摘要 |
| Source Files | 路径列表 |
| Qualification Score | -5 ~ 20 |
| Score Breakdown | R/E/X/S/B 分项 |
| Merge From | 若合并，原候选名列表 |
| Generated Time | ISO 日期 |
| Status | `generated` / `convention-only` / `discarded` |
| Verification State | `[已验证]` / `[推断]` |

## AGENTS.md 约束（≤60 行）

**允许**：项目简介、阅读顺序、Docs 表、Skills 表、Agent 入口一句。

**禁止**：架构细节、命令全文、排障步骤、中间件配置——指向 `docs/harness/*` 或 `skills/*`。
