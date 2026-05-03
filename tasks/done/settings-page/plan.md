# Plan: Settings Page

**Spec:** `tasks/active/settings-page/spec.md`
**Output:** `tasks/active/settings-page/todo.md`
**Status:** Ready for implementation

---

## Codebase Analysis

### Existing state

| File | Role | Relevant notes |
|------|------|----------------|
| `SimpleClockApp.swift` | App entry point | Bare `@main`, no environment objects injected |
| `ContentView.swift` | Main clock view | `TimelineView(.periodic(by: 5))`, shows HH:MM + SeparatorDots. No gesture, no sheet, no seconds, no date |
| `DesignTokens.swift` | Design tokens | Light/dark color variants already defined via `UIColor` trait collection — dark mode infrastructure exists but is not user-controllable |

### Key constraints

- `TimelineView` currently ticks every 5s. Must switch to 1s when `showSeconds` or `blinkingColon` is enabled; can drop back to 60s if neither requires sub-minute updates.
- `SeparatorDots` renders two static circles. Blinking colon requires opacity animation keyed to the second tick.
- `Color.init(light:dark:)` already handles system dark/light correctly. User-overriding appearance requires `.preferredColorScheme` on the root view, not changes to tokens.
- `AppSettings` must use `@Observable` (iOS 17) or `ObservableObject` (iOS 16+). Minimum deployment target is iOS 16.0 → use `ObservableObject` for compatibility.

---

## Dependency Graph

```
Task 1: AppSettings.swift
    ↓
Task 2: SettingsView.swift + ContentView access (gesture, sheet, gear icon)
    ↓                    ↓
Task 3: Appearance    Task 4: Clock display options
        mode toggle           (seconds, date, blinking colon)
```

Tasks 3 and 4 depend on Task 2 (settings sheet must exist to test toggles end-to-end), but are independent of each other and can be done in any order.

---

## Tasks

---

### Task 1: AppSettings persistence layer

**Description:** Create the `AppSettings` observable class that owns all UserDefaults-backed settings. Inject it into the SwiftUI environment via `SimpleClockApp`. This is the foundation everything else builds on.

**Files touched:**
- `SimpleClock/SimpleClock/AppSettings.swift` — new file
- `SimpleClock/SimpleClock/SimpleClockApp.swift` — inject `AppSettings` as environment object

**Acceptance criteria:**
- [ ] `AppSettings` is an `ObservableObject` with `@Published` properties for all 5 settings
- [ ] Each property is backed by `UserDefaults` with the `simpleclock.*` key prefix
- [ ] `darkMode` is `Bool?` (nil = follow system, unset on first launch)
- [ ] `AppSettings` instance is created once in `SimpleClockApp` and injected via `.environmentObject`
- [ ] Default values match the spec: `showSeconds: true`, `showDate: true`, `blinkingColon: false`, `showSettingsIcon: true`, `darkMode: nil`

**Verification:** Run app — behaviour unchanged. Confirm UserDefaults keys are written on first change (use Xcode debugger or print statements).

**Dependencies:** None
**Size:** S

---

### Task 2: SettingsView + access affordances

**Description:** Build the settings sheet UI and wire up both ways to open it: long-press on the clock and tapping the gear icon. Sheet contains all 5 toggles bound to `AppSettings` but display changes (seconds, date, blinking) are not yet wired to the clock view — that happens in Tasks 3 and 4.

**Files touched:**
- `SimpleClock/SimpleClock/SettingsView.swift` — new file
- `SimpleClock/SimpleClock/ContentView.swift` — add `@EnvironmentObject`, `@State var showSettings`, long-press gesture, `.sheet`, gear icon overlay

**Acceptance criteria:**
- [ ] Long-pressing anywhere on the clock screen opens the settings sheet
- [ ] Tapping the gear icon opens the settings sheet
- [ ] Sheet is a half-sheet: `.presentationDetents([.medium])`
- [ ] Sheet contains 3 `List` sections: Appearance / Clock Behaviour / Interface
- [ ] All 5 settings appear as labelled `Toggle` rows with correct defaults
- [ ] Toggling any setting writes to UserDefaults immediately (verify with AppSettings)
- [ ] Gear icon: SF Symbols `gearshape`, pinned bottom-right, 20% opacity (`Color.dsPrimary.opacity(0.2)`)
- [ ] Gear icon is visible by default and hidden when `showSettingsIcon` is OFF
- [ ] Sheet dismisses on swipe-down

**Verification:** Open app, long-press → sheet opens. Toggle each setting → value persists after app relaunch.

**Dependencies:** Task 1
**Size:** M

---

### Task 3: Appearance mode override

**Description:** Wire the `darkMode` setting to `.preferredColorScheme` on the root view so the user can force light or dark regardless of system setting.

**Files touched:**
- `SimpleClock/SimpleClock/ContentView.swift` — apply `.preferredColorScheme` based on `settings.darkMode`

**Acceptance criteria:**
- [ ] When `darkMode` is `nil`, app follows system appearance (no override)
- [ ] When `darkMode` is `true`, app is always dark regardless of system setting
- [ ] When `darkMode` is `false`, app is always light regardless of system setting
- [ ] Toggle in settings sheet changes appearance immediately without relaunch
- [ ] No visual regression on the clock display in either mode

**Verification:** Toggle dark mode in settings → clock switches immediately. Set device to opposite mode → app stays overridden.

**Dependencies:** Task 2
**Size:** S

---

### Task 4: Clock display options

**Description:** Wire the three remaining display settings to the clock view: show/hide seconds, show/hide date, and blinking colon. Also update `TimelineView` to use the correct tick interval based on active settings.

**Files touched:**
- `SimpleClock/SimpleClock/ContentView.swift` — conditional seconds, conditional date, `TimelineView` interval logic
- `SimpleClock/SimpleClock/ContentView.swift` (SeparatorDots) — blinking opacity animation keyed to second tick

**Acceptance criteria:**
- [ ] When `showSeconds` is ON, time displays as `HH:MM:SS`; when OFF, displays as `HH:MM`
- [ ] When `showDate` is ON, a date string (e.g. "Saturday, 3 May") appears below the time in `dsSecondary` colour; when OFF, it is hidden
- [ ] When `blinkingColon` is ON, `SeparatorDots` fades between full and zero opacity once per second, in sync with the second tick; when OFF, dots are always fully visible
- [ ] `TimelineView` uses 1s interval when `showSeconds || blinkingColon`; 60s interval otherwise
- [ ] All changes apply immediately when toggled in the settings sheet
- [ ] No regression to existing HH:MM display when both seconds and date are OFF

**Verification:** Toggle each setting in the running app — display updates instantly. Force-quit and relaunch — last state is restored.

**Dependencies:** Task 2
**Size:** M

---

## Checkpoints

```
[Task 1] → CHECKPOINT A: Settings persist to UserDefaults; app behaviour unchanged
[Task 2] → CHECKPOINT B: Sheet opens via long-press and gear tap; all toggles wired to AppSettings
[Tasks 3+4] → CHECKPOINT C: All settings have visible effect; no regressions
```

---

## Risk notes

- **`@Observable` vs `ObservableObject`:** Using `ObservableObject` for iOS 16 compatibility. Do not use `@Observable` (iOS 17+).
- **`TimelineView` interval switching:** The interval cannot be changed while `TimelineView` is active — the view must re-evaluate the schedule. Use a computed property that returns the correct `TimelineSchedule` based on current settings.
- **Blinking colon sync:** The simplest correct approach is to read `Calendar.current.component(.second, from: context.date)` inside the `TimelineView` closure and set dot opacity to `second % 2 == 0 ? 1.0 : 0.0`. This ensures exact sync with no floating timers.
- **`preferredColorScheme` placement:** Must be applied to the outermost view (on `ContentView` body or in `SimpleClockApp`) to override the full window.
