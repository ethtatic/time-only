---
description: Simplify code for clarity and maintainability — reduce complexity without changing behavior.
---

Read and apply the skill at `skills/code-simplification/SKILL.md`.

1. Review project conventions in CLAUDE.md (if present)
2. Target recently modified code or the specified scope
3. Understand the code's purpose, callers, edge cases, and existing tests before touching anything
4. Identify simplification opportunities:
   - Deep nesting → guard clauses or extracted helpers
   - Long functions → split by responsibility
   - Nested ternaries → explicit conditionals
   - Unclear names → descriptive identifiers
   - Duplicated logic → shared utilities
   - Dead code → remove entirely
5. Apply changes one at a time — run tests after each modification
6. If tests fail after a change, revert it and reassess

Verify all tests pass and the build succeeds before finishing.
Run `/review` for final quality check.
