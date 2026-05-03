# Todo: Settings Page

**Spec:** `tasks/active/settings-page/spec.md`
**Plan:** `tasks/active/settings-page/plan.md`

---

## Phase 1: Foundation

- [x] **Task 1: AppSettings persistence layer** — Create `AppSettings.swift` (`ObservableObject`, 5 `@Published` UserDefaults-backed properties); inject into `SimpleClockApp` via `.environmentObject`
  - Acceptance: All 5 settings persist across launches with correct defaults; app behaviour unchanged
  - Size: S

---

## CHECKPOINT A
App runs without visible change. UserDefaults keys write on first toggle. No regressions.

---

## Phase 2: Settings sheet

- [x] **Task 2: SettingsView + access affordances** — Create `SettingsView.swift` (half-sheet, 3 `List` sections, 5 `Toggle` rows); update `ContentView` with long-press gesture, `.sheet`, and `gearshape` overlay (bottom-right, 20% opacity, hideable)
  - Acceptance: Sheet opens via long-press and gear tap; all toggles write to UserDefaults; gear hides when `showSettingsIcon` OFF
  - Size: M

---

## CHECKPOINT B
Settings sheet opens from both access points. All 5 toggles visible and persisting. Gear icon shown/hidden correctly.

---

## Phase 3: Display wiring

- [x] **Task 3: Appearance mode override** — Apply `.preferredColorScheme` to root view based on `settings.darkMode` (nil = system, true = dark, false = light)
  - Acceptance: Toggle in settings changes appearance immediately; system override works; nil follows system
  - Size: S

- [x] **Task 4: Clock display options** — Wire `showSeconds` (HH:MM:SS), `showDate` (below clock, `dsSecondary`), `blinkingColon` (dot opacity keyed to second tick); update `TimelineView` to 1s when `showSeconds || blinkingColon`, else 60s
  - Acceptance: All three display settings apply immediately; blinking syncs to second tick; 60s interval when inactive
  - Size: M

---

## CHECKPOINT C
All 5 settings have visible effect. No regressions to base clock display. Settings persist across cold launches.
