---
description: Run the pre-launch checklist and prepare for production deployment.
---

Read and apply the skill at `skills/shipping-and-launch/SKILL.md`.

Run through the complete pre-launch checklist:

1. **Code Quality** — Tests pass, build clean, lint clean, no TODOs, no console.logs
2. **Security** — No secrets in code, auth in place, dependencies audited, headers configured
3. **Performance** — No N+1 queries, assets optimized, bundle sized appropriately
4. **Accessibility** — Keyboard nav works, screen reader compatible, contrast adequate
5. **Infrastructure** — Env vars set, migrations ready, monitoring configured
6. **Documentation** — README current, ADRs written, changelog updated

Report any failing checks and help resolve them before deployment.
Define the rollback plan before proceeding.
