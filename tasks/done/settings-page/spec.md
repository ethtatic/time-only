# Spec: Settings Page

**Status:** Draft — awaiting confirmation
**Feature folder:** `tasks/active/settings-page/`
**Created:** 2026-05-03

---

## Problem

SimpleClock has no way for users to personalise the experience. All display options are hardcoded. As the app grows, there needs to be an extensible, low-friction way to expose user-configurable options without cluttering the main clock interface.

---

## Goal

Ship a minimal v1 settings sheet that exposes the most valuable display toggles, built on a persistence foundation that future settings can slot into easily.

---

## Out of scope (deferred)

- Color and font themes (later milestone — see backlog)
- iCloud sync
- Haptics, sounds, Live Activities
- Keep screen on toggle

---

## Access pattern

**Long-press** on the clock screen opens the settings sheet.
The gesture is intentionally hidden — no affordance required to find it.
An optional settings icon on the clock face can hint at the gesture (and can be hidden by the user once they know it).

---

## Settings — v1

### Appearance

| Setting | Type | Default | Notes |
|---------|------|---------|-------|
| Appearance mode | Toggle: Dark / Light | System | Dark ON = dark mode, Dark OFF = light mode; follows system by default on first launch |
| Show seconds | Toggle | ON | Adds `:SS` to the time display |
| Show date | Toggle | ON | Shows date below the time |

### Clock behaviour

| Setting | Type | Default | Notes |
|---------|------|---------|-------|
| Blinking colon | Toggle | OFF | Animates the `:` separator every second in sync with the clock tick |

### Interface

| Setting | Type | Default | Notes |
|---------|------|---------|-------|
| Show settings icon | Toggle | ON | Displays a subtle gear icon on the clock screen as a hint; can be hidden once user knows the long-press gesture |

**Settings icon treatment:** SF Symbols `gearshape`, pinned to bottom-right corner, 20% opacity. Tapping it also opens the settings sheet (secondary affordance alongside long-press).

---

## Persistence

UserDefaults. Each setting is stored as a named key. A single `AppSettings` observable wrapper owns all keys and is injected via the SwiftUI environment.

```
simpleclock.showSeconds        Bool   default: true
simpleclock.showDate           Bool   default: true
simpleclock.blinkingColon      Bool   default: false
simpleclock.showSettingsIcon   Bool   default: true
simpleclock.darkMode           Bool   default: follows system on first launch (nil = unset)
```

---

## UI

- Native iOS `List`-based sheet, presented as a half-sheet (`.presentationDetents([.medium])`)
- Grouped sections matching the table above: Appearance / Clock Behaviour / Interface
- No custom chrome — standard iOS controls (Toggle)
- Sheet dismisses on swipe-down or tapping outside

---

## Acceptance criteria

- [ ] Long-pressing the clock screen opens the settings sheet
- [ ] All 5 settings are visible and functional
- [ ] Changes apply immediately (no save button required)
- [ ] Settings persist across app launches
- [ ] Dark/light toggle correctly overrides system appearance; nil (unset) follows system
- [ ] Blinking colon animates in sync with the clock's second tick when enabled
- [ ] Gear icon is pinned bottom-right at 20% opacity; tapping it also opens settings sheet
- [ ] Settings icon on clock face is shown/hidden based on the toggle
- [ ] No regression to existing clock display

---

## Decisions log

| Question | Decision |
|----------|----------|
| Appearance mode | Dark/light toggle (not 3-way picker); nil = follow system on first launch |
| Settings icon | SF Symbols `gearshape`, bottom-right, 20% opacity; tappable as secondary affordance |
| Sheet style | Half-sheet via `.presentationDetents([.medium])` |
