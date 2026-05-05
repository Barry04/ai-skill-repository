# evolving-skill

# 目标
让AI Agent 像老员工一样熟悉项目，快速完成项目任务。

A minimal in-agent skill layer using a single markdown file to store and reuse problem-solving patterns.


一个面向单项目的 Skill 层，用于沉淀重复出现的问题解决经验，并在同一代码环境中复用，从而提升 Agent 的稳定性与效率。

## What is this?

This project provides a lightweight skill harness for AI agents.

- Skills are stored in `skill.md`
- Behavior is defined in `skill/evolving-skill.md`
- Relevant skills are injected into prompts when needed

## Principles

- No service
- No database
- No vector store
- No framework dependency

## Structure

```

skill.md                 # Skill memory
skill/evolving-skill.md # Agent protocol

```

## Philosophy

This is NOT:

- a knowledge base
- a RAG system
- a platform

This IS:

- a prompt-level memory layer
- a reusable problem-solving pattern store
