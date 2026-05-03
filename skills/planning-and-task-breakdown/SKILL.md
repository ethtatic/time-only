---
name: planning-and-task-breakdown
description: Decompose work into atomic, verifiable tasks before writing code.
---

# Planning and Task Breakdown

## Overview

"Good task breakdown is the difference between an agent that completes work reliably and one that produces a tangled mess." Decompose work into manageable, verifiable tasks before writing a single line of code.

## When to Use

- Working from a spec that needs to be broken into implementable units
- A task feels too large or undefined to begin
- Work spans multiple sessions or agents
- You need to communicate project scope clearly

## Process

### Step 1: Read-Only Planning Mode

Study the spec and relevant codebase — do NOT write code. Understand:
- Existing patterns and conventions
- Type definitions and interfaces
- Component relationships

### Step 2: Map Dependencies

Identify the dependency graph between components. Determine what must be built before what:

```
Schema → Repository → Service → API endpoint → UI component
```

### Step 3: Vertical Slicing

Structure tasks as complete end-to-end paths, not horizontal layers:

```
❌ Horizontal (bad):
  Task 1: Build all database models
  Task 2: Build all API endpoints
  Task 3: Build all UI screens

✅ Vertical (good):
  Task 1: Time display feature (view model + view + tests)
  Task 2: Settings screen (persistence + view + tests)
  Task 3: Widget extension (shared model + widget view + tests)
```

Each completed task delivers working functionality.

### Step 4: Define Each Task

Every task includes:

```markdown
## Task N: [Short Name]

**Description:** What this task accomplishes
**Files touched:** List of files to create or modify
**Acceptance criteria:**
- [ ] Specific, testable condition 1
- [ ] Specific, testable condition 2
**Verification steps:** How to confirm the task is done
**Dependencies:** Which tasks must complete first
**Estimated size:** S (1-2 files) / M (3-5 files) / L (6+ files, consider splitting)
```

### Step 5: Insert Checkpoints

Add validation points between phases:

```
[Tasks 1-3] → CHECKPOINT: Core display works end-to-end
[Tasks 4-6] → CHECKPOINT: All features complete, no regressions
[Tasks 7-8] → CHECKPOINT: Ready for App Store submission
```

### Step 6: Review Gate

Present tasks/plan.md and tasks/todo.md to the user before implementation begins.

## Output Files

**tasks/plan.md** — Full planning document with dependency analysis, rationale, and risk notes.

**tasks/todo.md** — Actionable checklist:
```markdown
## Phase 1: Core
- [ ] Task 1: [name] — [one-line description]
- [ ] Task 2: [name] — [one-line description]

## Phase 2: Polish
- [ ] Task 3: [name] — [one-line description]
```

## Sizing Guide

An agent performs best on S and M tasks — those touching 1-5 files. Tasks should fit within a single focused work session (~2 hours).

| Size | Files | Duration |
|------|-------|----------|
| S | 1-2 | < 30 min |
| M | 3-5 | 30-120 min |
| L | 6+ | Split it |

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I can keep the plan in my head" | Write it down. Unwritten plans drift and create unverifiable progress. |
| "The tasks are too simple to document" | Simple tasks take 2 minutes to document and save hours of confusion. |
| "We'll figure out the order as we go" | Dependency surprises mid-implementation cause rework. Map them first. |

## Red Flags

- Starting implementation without a written task list
- Tasks with no acceptance criteria ("implement auth" is not a task)
- Tasks that span more than 5 files without a split strategy
- No verification steps defined for any task
- Plan was never shown to the user before coding started

## Verification

- [ ] tasks/plan.md created with dependency analysis
- [ ] tasks/todo.md created with all tasks and acceptance criteria
- [ ] Each task has testable acceptance criteria
- [ ] Dependencies are ordered correctly
- [ ] Plan reviewed and confirmed by user before implementation
