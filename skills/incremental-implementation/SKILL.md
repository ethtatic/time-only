---
name: incremental-implementation
description: Delivers changes incrementally. Use when implementing any feature or change that touches more than one file.
---

# Incremental Implementation

## Overview

Build in thin vertical slices — implement one piece, test it, verify it, then expand. Avoid implementing an entire feature in one pass. Each increment should leave the system in a working, testable state.

## When to Use

- Implementing any multi-file change
- Building a new feature from a task breakdown
- Refactoring existing code
- Any time you're tempted to write more than ~100 lines before testing

**When NOT to use:** Single-file, single-function changes where the scope is already minimal.

## The Increment Cycle

```
Implement ──→ Test ──→ Verify ──┐
    ▲                           │
    └───── Commit ◄─────────────┘
           │
           ▼
       Next slice
```

For each slice:
1. **Implement** the smallest complete piece of functionality
2. **Test** — run the test suite (or write a test if none exists)
3. **Verify** — confirm the slice works (tests pass, build succeeds, manual check)
4. **Commit** — save progress with a descriptive message
5. **Move to the next slice**

## Implementation Rules

### Rule 0: Simplicity First

Before writing any code, ask: "What is the simplest thing that could work?"

After writing code:
- Can this be done in fewer lines?
- Are these abstractions earning their complexity?
- Am I building for hypothetical future requirements, or the current task?

Three similar lines of code is better than a premature abstraction. Implement the naive, obviously-correct version first.

### Rule 0.5: Scope Discipline

Touch only what the task requires. Do NOT:
- "Clean up" code adjacent to your change
- Refactor imports in files you're not modifying
- Add features not in the spec because they "seem useful"

If you notice something worth improving outside your task scope, note it — don't fix it:
```
NOTICED BUT NOT TOUCHING:
- ContentView.swift has an unused import (unrelated to this task)
→ Want me to create a task for this?
```

### Rule 1: One Thing at a Time

Each increment changes one logical thing. Don't mix concerns.

### Rule 2: Keep It Compilable

After each increment, the project must build and existing tests must pass.

### Rule 3: Rollback-Friendly

Each increment should be independently revertable. Additive changes are easy to revert. Prefer adding before deleting.

## Increment Checklist

After each increment, verify:

- [ ] The change does one thing and does it completely
- [ ] All existing tests still pass
- [ ] The build succeeds
- [ ] The new functionality works as expected
- [ ] The change is committed with a descriptive message

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll test it all at the end" | Bugs compound. A bug in Slice 1 makes Slices 2–5 wrong. |
| "It's faster to do it all at once" | It *feels* faster until something breaks and you can't find which of 500 changed lines caused it. |
| "This refactor is small enough to include" | Refactors mixed with features make both harder to review and debug. |

## Red Flags

- More than 100 lines of code written without running tests
- Multiple unrelated changes in a single increment
- "Let me just quickly add this too" scope expansion
- Build or tests broken between increments
- Large uncommitted changes accumulating
- Creating new utility files for one-time operations

## Verification

After completing all increments for a task:

- [ ] Each increment was individually tested and committed
- [ ] The full test suite passes
- [ ] The build is clean
- [ ] The feature works end-to-end as specified
- [ ] No uncommitted changes remain
