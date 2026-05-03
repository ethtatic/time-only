---
name: code-review-and-quality
description: Multi-dimensional code review with quality gates. Every change reviewed before merge — no exceptions.
---

# Code Review and Quality

## Overview

Multi-dimensional code review with quality gates. Every change gets reviewed before merge — no exceptions. Review covers five axes: correctness, readability, architecture, security, and performance.

**The approval standard:** "Approve a change when it definitely improves overall code health, even if it isn't perfect."

## When to Use

- Before merging any PR or change
- After completing a feature implementation
- When another agent or model produced code you need to evaluate
- After any bug fix (review both the fix and the regression test)

## The Five-Axis Review

### 1. Correctness
Does the code do what it claims? Check:
- Matches the spec / acceptance criteria
- Handles edge cases and error paths
- Has adequate test coverage
- Doesn't introduce regressions

### 2. Readability & Simplicity
"Can another engineer understand this code without the author explaining it?"
- Naming is clear and intention-revealing
- Control flow is straightforward (no unnecessary nesting)
- No unnecessary abstractions
- Comments explain *why*, not *what*

### 3. Architecture
Does the change fit the system's design?
- Follows existing patterns and conventions
- Maintains clean module/layer boundaries
- No code duplication
- No circular dependencies
- Appropriate abstraction level

### 4. Security
- All user input validated and sanitized
- No secrets in code, logs, or version control
- Auth/permission checks in place
- External data treated as untrusted
- See `skills/security-and-hardening/SKILL.md` for full checklist

### 5. Performance
- No N+1 query patterns in critical paths
- No unbounded loops or queries
- Appropriate async handling
- Pagination where needed
- See `skills/performance-optimization/SKILL.md` for full checklist

## Change Sizing

| Size | Target | Acceptable | Split Required |
|------|--------|------------|----------------|
| Lines | ~100 | ~300 | 1000+ |

## Review Process

1. **Understand Context** — What problem does this solve? Read the task/spec first.
2. **Review Tests First** — Do tests adequately validate the behavior?
3. **Review Implementation** — Apply the five axes systematically
4. **Categorize Findings** — Mark each finding:
   - **Critical** — Must fix before merge (correctness, security)
   - **Important** — Should fix before merge (readability, architecture)
   - **Suggestion** — Optional improvement (style, minor optimization)
5. **Verify Verification** — Was testing done? Build clean?

## Output Format

```
## Review: [file or feature name]

### Correctness
- [Critical] src/Clock.swift:42 — Timer not invalidated on view disappear → memory leak
  Fix: Call timer.invalidate() in .onDisappear

### Readability
- [Suggestion] ContentView.swift:8 — `now` could be named `currentTime` for clarity

### Architecture
✓ Follows existing MVVM pattern

### Security
✓ No user input, no secrets

### Performance
✓ Timer fires at 1-second interval — appropriate for a clock
```

## Key Principles

- "Don't rubber-stamp. 'LGTM' without evidence of review helps no one."
- Separate refactoring PRs from feature PRs
- Require cleanup before approval, not after
- Review the test as carefully as the implementation

## Red Flags

- Approving without reading the diff
- No tests in the change
- Mixing refactoring with behavior changes
- Findings left as "we'll fix later" without a task created

## Verification

- [ ] All five axes reviewed
- [ ] All Critical findings addressed before merge
- [ ] Tests reviewed for adequacy
- [ ] Build and lint passing
- [ ] Change size is reviewable (~300 lines or less)
