---
description: Five-axis code review — correctness, readability, architecture, security, performance.
---

Read and apply the skill at `skills/code-review-and-quality/SKILL.md`.

Review the specified changes (or recent uncommitted changes) across five axes:

1. **Correctness** — Spec compliance, edge cases, error paths, test coverage
2. **Readability** — Naming clarity, control flow, organizational structure
3. **Architecture** — Pattern consistency, module boundaries, abstraction level
4. **Security** — Input validation, secrets, auth checks (see `skills/security-and-hardening/SKILL.md`)
5. **Performance** — N+1 queries, unbounded operations, async opportunities (see `skills/performance-optimization/SKILL.md`)

Categorize findings: Critical | Important | Suggestion
Include file:line references and specific fix recommendations for each finding.
