# Todo: App Icon Redesign

**Spec:** `SPEC.md`
**Plan:** `tasks/plan.md`

---

## Phase 1: Design (manual step — must come first)

- [ ] **Task 1: Icon artboards in SimpleClock.pen** — Add three 1024×1024 artboards ("Icon — Light", "Icon — Dark", "Icon — Tinted") to the components lane; each shows "10:10" in ultralight system font on a flat background; nothing else
  - Acceptance: All three artboards exist with correct colors, reviewed and approved
  - Size: S

---

## CHECKPOINT A
All three icon designs visible and approved in SimpleClock.pen. Ready to build.

---

## Phase 2: Generator + Asset Catalog

- [x] **Task 2: Generator script + asset catalog wiring** — Write `scripts/generate-icon.swift` (CoreGraphics + CoreText, no dependencies); render "10:10" in three color variants at 1024×1024; output PNGs to asset catalog; update `Contents.json` with all three `filename` entries; delete old `AppIcon-1024.png`
  - Acceptance: `swift scripts/generate-icon.swift` produces 3 PNGs; idempotent; Contents.json fully wired; icon visible in Xcode and on simulator home screen
  - Size: M

---

## CHECKPOINT B
Script runs cleanly from repo root. Three PNGs in asset catalog. Contents.json has filename for all three variants. Icon renders correctly on simulator home screen. No Xcode build errors.
