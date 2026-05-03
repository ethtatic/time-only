---
name: spec-driven-development
description: Write a structured specification before writing code. Forces clarity upfront, preventing rework.
---

# Spec-Driven Development

## Overview

Write a structured specification before writing code. "Code without a spec is guessing." A 15-minute spec prevents hours of rework by establishing testable success criteria and boundaries before development begins.

## When to Use

- New projects or features lacking clear requirements
- Ambiguous or incomplete requirements
- Changes affecting multiple files or modules
- Architectural decisions requiring documentation
- Tasks exceeding 30 minutes of implementation time

## Process

### Phase 1: Surface Assumptions

Before writing any spec content, list what you're assuming so corrections can happen early:

```
ASSUMPTIONS:
- The app targets iOS 17+
- SwiftUI is the UI framework
- No backend required
- Single-screen app
```

### Phase 2: Clarify

Ask the user about:
1. **Objective** — What is being built and who will use it?
2. **Features** — What are the core features and acceptance criteria?
3. **Tech stack** — Any preferences or constraints?
4. **Boundaries** — What to always do, ask first about, and never do?

### Phase 3: Generate SPEC.md

Produce a SPEC.md covering six areas:

```markdown
# SPEC.md

## Objective
[What this builds and who it's for]

## Commands
[Key commands to build, test, run the project]

## Project Structure
[Directory layout and key files]

## Code Style
[Language, formatting, naming conventions]

## Testing Strategy
[What to test, how, and at what level]

## Boundaries
- Always: [non-negotiable practices]
- Ask first: [things requiring approval]
- Never: [hard constraints]
```

### Phase 4: Confirm

Save SPEC.md to the project root. Present it to the user and confirm before advancing to implementation.

### Phase 5: Keep It Live

Update SPEC.md when decisions, scope, or architecture changes. Commit alongside code — the spec is documentation.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The requirements are obvious" | Write them down. What's obvious to you isn't obvious to future you or collaborators. |
| "We'll spec it after a prototype" | Prototypes become production. Spec first, then build. |
| "The spec will just change anyway" | A living spec is better than no spec. Update it as decisions are made. |

## Red Flags

- Starting to write code before clarifying requirements
- Requirements exist only in conversation (not written down)
- No clear acceptance criteria for the feature
- Spec has never been updated after initial creation

## Verification

- [ ] Assumptions are listed and confirmed
- [ ] All six SPEC.md sections are populated
- [ ] Acceptance criteria are testable (not vague)
- [ ] User confirmed the spec before implementation began
- [ ] SPEC.md is committed to version control
