---
name: code-simplification
description: Simplify code for clarity and maintainability — reduce complexity without changing behavior.
---

# Code Simplification

## Overview

Simplify code for clarity and maintainability — reduce complexity without changing behavior. "The goal is not fewer lines — it's code that is easier to read, understand, modify, and debug."

## When to Use

- After completing a feature (clean up before the PR)
- When code review flags complexity
- When you find yourself re-reading code multiple times to understand it

**When NOT to use:**
- Already-clean code
- Code you don't fully understand yet
- Performance-critical sections that complexity serves
- Code facing a complete rewrite

## Process

### Step 1: Understand First (Chesterton's Fence)

Before changing anything, understand *why* the code is the way it is. Complexity often exists for a reason. Identify:
- What does this code do?
- Who calls it?
- What edge cases does it handle?
- What tests cover it?

### Step 2: Identify Opportunities

Look for these patterns:

| Pattern | Simplification |
|---------|---------------|
| Deep nesting (3+ levels) | Guard clauses or extracted helpers |
| Long functions (30+ lines) | Split by single responsibility |
| Nested ternary operators | Explicit if/else or switch |
| Unclear variable names | Descriptive identifiers |
| Duplicated code blocks | Shared utility (only after 3rd use) |
| Dead/unreachable code | Delete it |
| Comment explaining what code does | Rename so it's self-explanatory |

### Step 3: Change Incrementally

Make ONE change at a time. Run tests after each change.

```
Change → Test → Verify → (next change)
```

If tests fail after a change, **revert it immediately** and reassess. Do not accumulate failing changes.

### Step 4: Verify Genuinely Simpler

After each simplification, ask:
- Is this actually easier to understand?
- Does it align with existing codebase patterns?
- Would a reviewer understand it faster than before?

## Simplification Examples (Swift/SwiftUI)

**Before (deep nesting):**
```swift
func formatTime(_ date: Date) -> String {
    if date != nil {
        if calendar.isDateInToday(date) {
            if use24Hour {
                return formatter24.string(from: date)
            } else {
                return formatter12.string(from: date)
            }
        }
    }
    return ""
}
```

**After (guard clauses):**
```swift
func formatTime(_ date: Date) -> String {
    guard calendar.isDateInToday(date) else { return "" }
    return use24Hour ? formatter24.string(from: date) : formatter12.string(from: date)
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I understand it, so it's fine" | Code is read far more than it is written. Optimize for the reader. |
| "I'll simplify it later" | Later never comes. Simplify before merging. |
| "Fewer lines = simpler" | Not always. Explicit code beats compact code when brevity requires mental effort. |

## Red Flags

- Simplification changes observable behavior
- Tests fail after "simplification"
- "Simplification" removes error handling that was intentional
- Simplifying code you don't fully understand yet

## Verification

- [ ] All tests pass after each incremental change
- [ ] Build succeeds
- [ ] Simplified code is genuinely easier to read
- [ ] No behavior changes — identical outputs for all inputs
- [ ] Aligns with existing project conventions
- [ ] Run `/review` for final quality check
