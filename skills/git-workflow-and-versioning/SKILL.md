---
name: git-workflow-and-versioning
description: Treat commits as save points, branches as sandboxes, and history as documentation.
---

# Git Workflow and Versioning

## Overview

Git is your safety net. Treat commits as save points, branches as sandboxes, and history as documentation. Disciplined version control keeps changes manageable, reviewable, and reversible.

## Core Principles

### 1. Commit Early, Commit Often

Each successful increment gets its own commit. Don't accumulate large uncommitted changes.

```
Work pattern:
  Implement slice → Test → Verify → Commit → Next slice
```

### 2. Atomic Commits

Each commit does one logical thing:

```
# Good
feat: add timer that updates display every second
test: add unit tests for ClockViewModel tick behavior
fix: prevent layout jump when digit width changes

# Bad
update stuff, fix things, add feature
```

### 3. Descriptive Messages

Commit messages explain the *why*, not just the *what*:

```
feat: use monospacedDigit() modifier on time display

Prevents layout shifts as digits change width each second.
Without this modifier, the surrounding UI shifts slightly
every time a narrow digit (1) is replaced by a wide one (0).
```

**Message format:**
```
<type>: <short description>

<optional body explaining why>
```

**Types:** `feat` | `fix` | `refactor` | `test` | `docs` | `chore`

### 4. Keep Concerns Separate

Don't combine formatting changes with behavior changes. Each type of change is a separate commit.

### 5. Size Your Changes

```
~100 lines → Easy to review, easy to revert
~300 lines → Acceptable for a single logical change
1000+ lines → Split into smaller changes
```

## Branching

```
main (always buildable)
  │
  ├── feature/world-clock     ← One feature per branch
  ├── feature/widget          ← Parallel work
  └── fix/timer-memory-leak   ← Bug fixes
```

- Branch from `main`
- Keep branches short-lived — merge within 1-3 days
- Delete branches after merge
- Prefer feature flags over long-lived branches for incomplete work

## Branch Naming

```
feature/<short-description>   → feature/world-clock
fix/<short-description>       → fix/timer-leak
chore/<short-description>     → chore/update-deps
refactor/<short-description>  → refactor/clock-view-model
```

## Change Summaries

After any modification, provide:

```
CHANGES MADE:
- SimpleClock/ContentView.swift: Added timer subscription
- SimpleClock/ContentView.swift: Applied monospacedDigit() modifier

THINGS I DIDN'T TOUCH (intentionally):
- SimpleClockApp.swift: Entry point unchanged

POTENTIAL CONCERNS:
- Timer fires on main runloop — correct for UI updates, confirm this is intended
```

## Pre-Commit Checklist

- [ ] `git diff --staged` reviewed — no surprises
- [ ] No secrets or API keys in the diff
- [ ] Build succeeds
- [ ] Tests pass
- [ ] Commit message explains the *why*

## Xcode-Specific .gitignore

```gitignore
# Xcode
*.xcworkspace/xcuserdata/
*.xcodeproj/xcuserdata/
*.xcodeproj/project.xcworkspace/xcuserdata/
DerivedData/
*.ipa
*.dSYM.zip
*.dSYM

# macOS
.DS_Store

# SwiftPM
.build/
.swiftpm/

# Project-specific
cowork/
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll commit when the feature is done" | One giant commit is impossible to review or revert. Commit each slice. |
| "The message doesn't matter" | Messages are documentation. They explain decisions that the code itself can't. |
| "Branches add overhead" | Short-lived branches are free. Long-lived branches are the problem. |

## Red Flags

- Large uncommitted changes accumulating
- Commit messages like "fix", "update", "wip"
- Mixing formatting changes with behavior changes
- `.DS_Store` or `DerivedData/` committed

## Verification

For every commit:

- [ ] Does one logical thing
- [ ] Message explains the why
- [ ] Tests pass before committing
- [ ] No secrets in the diff
- [ ] No unrelated changes mixed in
