# Todo: Colon Color Setting

**Plan:** `tasks/plan.md`

---

## Phase 1: Design (manual step — must come first)

- [ ] **Task 1: Update SimpleClock.pen** — Add "Colon Color" row (color swatch + label) to the "Clock" section of the settings screen artboard; include a "Reset to Default" affordance visible when a custom color is active
  - Acceptance: Settings artboard updated and design approved before build begins
  - Size: S

---

## CHECKPOINT A
SimpleClock.pen settings screen shows the color picker row. Design reviewed and approved. Ready to build.

---

## Phase 2: Implementation

- [ ] **Task 2: AppSettings — colonColor persistence** — Add `colonColor: Color?` property to `AppSettings` (`nil` = default accent); persist as RGBA `[Double]` in UserDefaults; add `Color.rgbaComponents` helper in `DesignTokens.swift`
  - Acceptance: Setting and re-loading `colonColor` round-trips correctly; `nil` removes the key
  - Files: `AppSettings.swift`, `DesignTokens.swift`
  - Size: S

- [ ] **Task 3: ContentView — wire color to SeparatorDots** — Add `color: Color = .dsAccent` param to `SeparatorDots`; update call site in `ContentView` to pass `settings.colonColor ?? .dsAccent`
  - Acceptance: Default behavior unchanged; custom color updates dots reactively
  - Files: `ContentView.swift`
  - Size: S

- [ ] **Task 4: SettingsView — ColorPicker + reset** — Add `ColorPicker("Colon Color", ...)` and conditional "Reset to Default" button to the "Clock" section
  - Acceptance: Picker shows default orange; selecting a color updates colon live; reset button visible only with custom color; color persists across app restarts
  - Files: `SettingsView.swift`
  - Size: S

---

## CHECKPOINT B
App builds cleanly. Colon color is user-selectable in Settings. Persists across launches. Reset restores default orange. No regressions to existing settings.

---

## Phase 3: Tests

- [ ] **Task 5: Tests — AppSettings colonColor persistence** — Add 4 unit tests: default nil, set+persist, re-init round-trip, nil reset; use isolated `UserDefaults(suiteName:)`
  - Acceptance: All 4 tests pass; `Cmd+U` green
  - Files: `SimpleClockTests.swift`
  - Size: S

---

## CHECKPOINT C
All unit tests pass. Full feature complete and verified.
