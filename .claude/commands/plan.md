---
description: Decompose work into atomic, verifiable tasks. Read spec and codebase, map dependencies, output tasks/plan.md and tasks/todo.md.
---

Read and apply the skill at `skills/planning-and-task-breakdown/SKILL.md`.

Enter read-only planning mode — do not write code.

1. Read SPEC.md (if it exists) and relevant codebase sections
2. Identify the dependency graph between components
3. Decompose work into vertical slices (feature paths, not layers)
4. Define acceptance criteria and verification steps for each task
5. Insert phase checkpoints between major sections
6. Present the plan for review before implementation begins

Output:
- `tasks/plan.md` — detailed planning document with rationale and dependencies
- `tasks/todo.md` — actionable task list with acceptance criteria and verification steps

Options: `--spec <path>` to use a different spec file, `--output <dir>` to change output directory.
