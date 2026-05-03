# Todo: Project Structure Cleanup

## Phase 1: Safe Removals & Updates

- [x] **Task 1: Delete `_staged/`** — Remove the entire `_staged/` directory. It contains an obsolete pre-design-system `ContentView.swift` (Combine timer, hardcoded colors) that has been superseded by the live Xcode source.
  - Acceptance: `_staged/` directory no longer exists at project root.
  - Size: S

- [x] **Task 2: Mark design token tasks complete in tasks/todo.md** — All 4 tasks from the design token migration are done. Update this file to reflect reality, then add the new cleanup tasks as the active work.
  - Acceptance: No tasks marked [ ] for completed work.
  - Size: S

- [x] **Task 3: Update `cowork/ROADMAP.md` decisions log** — Fill in known values: app name (SimpleClock), bundle ID (`com.pennewiss.simpleclock`), pricing ($0.99 paid).
  - Acceptance: Decisions log has no TBD rows for values already decided.
  - Size: S

- [x] **Task 4: Mark `SPEC.md` as completed** — Add a "Status: Complete" header to SPEC.md so it's clear this spec has been implemented and is now reference-only. Do not delete it — it documents the design system contracts.
  - Acceptance: SPEC.md has a clear "Status: Implemented" note at the top.
  - Size: S

## Phase 2: Requires Confirmation

- [x] **Task 5: Clarify `design.pen` vs `SimpleClock.pen`** — Two `.pen` files exist at root. User must confirm whether `design.pen` is an older duplicate before it is deleted. SPEC.md names `SimpleClock.pen` as the design source of truth.
  - Acceptance: One canonical `.pen` file remains; the other is deleted or renamed with clear purpose.
  - Dependency: User confirmation required first.
  - Size: S

## Structural Note (future decision, not this pass)

The outer `simpleclock/` root is not tracked by git — only `SimpleClock/.git/` exists. CLAUDE.md, SPEC.md, tasks/, skills/, and .claude/ are all unversioned. Consider moving the git root up or adding git tracking at the project root in a future pass.
