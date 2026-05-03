# Plan: Project Structure Cleanup

## Analysis

### Current State

The project root has accumulated redundant and stale artifacts from earlier phases of development. The Xcode project and design system are now fully in place, but several files/folders no longer serve a purpose or have drifted out of sync with reality.

### Findings

#### 1. `_staged/ContentView.swift` — OBSOLETE
The `_staged/` folder was created to hold source files "pending Xcode project creation" (per CLAUDE.md). The Xcode project now exists and has a fully implemented, up-to-date `ContentView.swift` using design tokens. The staged file still uses the old Combine-based timer and hardcoded `Color.black`/`.white` — it predates the design system entirely.

**Action:** Delete `_staged/` directory.

#### 2. `tasks/plan.md` and `tasks/todo.md` — STALE (all tasks complete)
Both files describe the design token migration (Tasks 1–4). All tasks are still marked `[ ]` but the work is demonstrably done:
- `DesignTokens.swift` exists with all color/font/spacing tokens
- `ContentView.swift` uses `Color.dsBackground`, `Color.dsPrimary`, `Color.dsAccent`, `Font.dsDisplay`, `Spacing.sm`
- No Combine import anywhere — `TimelineView` is used instead

**Action:** Mark all 4 tasks complete; replace with next planning cycle.

#### 3. `design.pen` — LIKELY DUPLICATE
Two `.pen` design files exist at the root: `SimpleClock.pen` and `design.pen`. SPEC.md designates `SimpleClock.pen` as the design source of truth. `design.pen` is not referenced anywhere in CLAUDE.md, SPEC.md, or any command files.

**Action:** Confirm with user whether `design.pen` is an older/duplicate file and can be deleted.

#### 4. `cowork/ROADMAP.md` decisions log — STALE
The decisions log shows TBD for app name, bundle ID, and pricing. CLAUDE.md already records:
- Bundle ID: `com.pennewiss.simpleclock`
- Pricing: $0.99 (paid app)
- App name: SimpleClock (implied)

**Action:** Update the decisions log in ROADMAP.md.

#### 5. `SPEC.md` — COMPLETED SPEC, no next spec
SPEC.md describes the Pencil.dev design system setup spec, which is fully implemented. There is no current/active spec for what comes next.

**Action:** Archive SPEC.md as `SPEC-design-system.md` or note it as completed at the top, and leave placeholder for the next spec when it's written.

#### 6. Git repo nested at `SimpleClock/.git/` — STRUCTURAL NOTE
The outer `simpleclock/` root is not a git repo. All meta files (CLAUDE.md, SPEC.md, tasks/, skills/, cowork/, .claude/) are not tracked by any version control. Only the Xcode project files inside `SimpleClock/` are versioned.

This is a structural risk — design files, specs, and workflow configs are untracked. Not in scope for this cleanup pass, but worth a future decision.

**Action:** Flag for user decision (not changed now).

### Dependencies

```
Task 1 (delete _staged/) — no dependencies
Task 2 (update tasks/) — no dependencies
Task 3 (update ROADMAP.md) — no dependencies
Task 4 (clarify design.pen) — requires user confirmation first
Task 5 (mark SPEC.md completed) — no dependencies
```

Tasks 1, 2, 3, 5 are safe to execute in any order. Task 4 waits on user input.
