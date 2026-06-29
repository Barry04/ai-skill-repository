---
name: skillopt-adapter
description: >-
  MUST use when evaluating, benchmarking, regression-testing, or optimizing
  repository skills with SkillOpt. Use when the user mentions SkillOpt, skill
  优化, 自动优化 Skill, skill benchmark, skill regression, validation gate,
  best_skill.md, proposal review, or asks to turn a skill change into a scored
  preview-first proposal.
---

# SkillOpt Adapter

## Purpose

Connect this repository's human-reviewed Skill governance with SkillOpt-style
offline optimization. SkillOpt may propose changes, but the formal record stays
in `skill/<name>/SKILL.md` and changes require preview and user confirmation.

## When To Use

Triggers:

- `SkillOpt`
- `skill 优化`
- `自动优化 Skill`
- `skill benchmark`
- `skill regression`
- `validation gate`
- `best_skill.md`
- proposal review

Use for high-frequency skills that have repeatable tasks and scoreable expected
behavior. Prefer troubleshooting, deployment, and project-harness workflows.
Avoid one-off user preferences, secrets, production host details, and unscored
governance-only protocols.

## Hard Rules

- Never overwrite `skill/<name>/SKILL.md` with SkillOpt output directly.
- Write optimization results to `experiments/skillopt/<skill>/<run-id>/`.
- Convert candidate output into `proposals/<skill>/<date>-skillopt.md`.
- A proposal must include validation summary, proposed diff, risks, and an
  adoption checklist.
- CI may run deterministic regression scoring, but must not call paid or
  nondeterministic model optimization.
- User confirmation is required before any proposal is merged into `skill/`.

## Workflow

1. Select one skill with an existing `skill/<name>/SKILL.md`.
2. Confirm `eval/<name>/rubric.md` and `eval/<name>/cases/*.json` exist.
3. Run regression scoring before optimization.
4. Run SkillOpt locally or use a mock `best_skill.md` during dry runs.
5. Generate a proposal from the candidate output.
6. Review the proposal with `scripts/skillopt/promote-proposal.ps1`.
7. If the user approves, manually merge the change and run regression again.

## Evaluation Case Contract

Each JSON case must contain:

- `id`
- `skill`
- `input`
- `context`
- `expected`
- `forbidden`
- `score_points`
- `tags`

Scoring is deterministic in CI. A case fails when required expected phrases are
missing or forbidden phrases appear in the candidate skill text.

## Proposal Contract

Proposal files must contain these headings:

- `Source Skill`
- `SkillOpt Run`
- `Validation Summary`
- `Proposed Diff`
- `Risk Review`
- `Adoption Checklist`

The proposal is the review artifact. It is not the source of truth until a user
approves merging it into `skill/`.

