# Plan: Colon Color Setting

**Feature:** User-selectable color for the colon separator dots, with a reset-to-default option.
**Status:** Ready for implementation

---

## Codebase Analysis

### Relevant files

| File | Role | Key detail |
|------|------|------------|
| `ContentView.swift` | Clock display | `SeparatorDots` at line 97 uses `Color.dsAccent` hardcoded (`#FF6B35`) |
| `AppSettings.swift` | Persistent settings | `@Published var X { didSet { defaults.set(...) } }` pattern; `init` loads from UserDefaults |
| `SettingsView.swift` | Settings UI | "Clock" section already contains "Blinking Colon" toggle — natural home for color picker |
| `DesignTokens.swift` | Design tokens | `dsAccent = Color(hex: 0xFF6B35)` is the default colon color |
| `SimpleClock.pen` | Design source | Settings screen must be updated before build (per workflow) |

### Current colon rendering

```swift
// ContentView.swift:97-110
struct SeparatorDots: View {
    var blinking: Bool = false
    var second: Int = 0

    var body: some View {
        VStack(spacing: 18) {
            Circle().frame(width: 8, height: 8)
            Circle().frame(width: 8, height: 8)
        }
        .foregroundStyle(Color.dsAccent)   // ← hardcoded orange
        .opacity(blinking && second % 2 != 0 ? 0 : 1)
        .animation(.easeInOut(duration: 0.25), value: second)
    }
}
```

---

## Dependency Graph

```
Task 1 (Design — SimpleClock.pen)
    ↓
Task 2 (AppSettings — colonColor persistence)
    ↓
Task 3 (ContentView — wire color to SeparatorDots)
    ↓
Task 4 (SettingsView — ColorPicker + reset UI)
    ↓
Task 5 (Tests — AppSettings persistence round-trip)
```

Tasks 3 and 4 both depend on Task 2. Tasks 3 and 4 can be done in either order but Task 3 is simpler and should come first to unblock visual verification.

---

## Tasks

---

### Task 1: Update SimpleClock.pen — settings screen with color picker (DESIGN — manual step)

**Description:** Update the settings screen artboard in `SimpleClock.pen` to show the colon color picker row in the "Clock" section. Add a component state showing the active color swatch and a "Reset to Default" button.

**Files touched:**
- `SimpleClock.pen` — settings screen artboard in the components lane

**What to add:**
- In the "Clock" section of the settings screen, add a row: label "Colon Color" + color swatch preview on the right
- Add a "Reset to Default" state showing how the reset affordance appears (e.g., a secondary "Default" button below the color picker row, visible only when a custom color is active)

**Acceptance criteria:**
- [ ] Settings screen artboard shows "Colon Color" row in the "Clock" section
- [ ] Color swatch preview is visible on the right side of the row
- [ ] A "Reset to Default" affordance is shown
- [ ] Design is reviewed and approved before build begins

**Verification:** Open SimpleClock.pen, review the settings screen artboard.

**Dependencies:** None
**Size:** S (design only)

---

### Task 2: AppSettings — colonColor persistence

**Description:** Add a `colonColor: Color?` property to `AppSettings`. `nil` means "use default" (`dsAccent`). Store as RGBA `[Double]` in UserDefaults — consistent with the existing `@Published` pattern. Add a `Color` extension for RGBA round-trip serialization.

**Files touched:**
- `SimpleClock/SimpleClock/AppSettings.swift` — add `colonColor` property + key + init
- `SimpleClock/SimpleClock/DesignTokens.swift` — add `Color` RGBA extension

**Implementation sketch:**

```swift
// DesignTokens.swift — new Color extension
extension Color {
    var rgbaComponents: [Double]? {
        guard let components = UIColor(self).cgColor.components,
              components.count >= 3 else { return nil }
        let r = components[0], g = components[1], b = components[2]
        let a = components.count >= 4 ? components[3] : 1.0
        return [Double(r), Double(g), Double(b), Double(a)]
    }
}

// AppSettings.swift — new property
@Published var colonColor: Color? {
    didSet {
        if let comps = colonColor?.rgbaComponents {
            defaults.set(comps, forKey: Keys.colonColor)
        } else {
            defaults.removeObject(forKey: Keys.colonColor)
        }
    }
}

// AppSettings.swift — init
if let comps = defaults.object(forKey: Keys.colonColor) as? [Double], comps.count == 4 {
    self.colonColor = Color(red: comps[0], green: comps[1], blue: comps[2], opacity: comps[3])
} else {
    self.colonColor = nil
}

// AppSettings.Keys
static let colonColor = "simpleclock.colonColor"
```

**Acceptance criteria:**
- [ ] `colonColor: Color?` property exists on `AppSettings`; `nil` = default
- [ ] Setting a color persists to UserDefaults and survives an `AppSettings` re-init
- [ ] Setting `colonColor = nil` removes the key from UserDefaults
- [ ] `rgbaComponents` extension compiles and round-trips correctly for known colors

**Verification:** Unit tests (Task 5) + manual Xcode build with no errors.

**Dependencies:** Task 1
**Size:** S

---

### Task 3: ContentView — wire colonColor to SeparatorDots

**Description:** Update `SeparatorDots` to accept an explicit `color: Color` parameter. Update `ContentView` to pass `settings.colonColor ?? .dsAccent` as the color.

**Files touched:**
- `SimpleClock/SimpleClock/ContentView.swift`

**Changes:**
```swift
// SeparatorDots — add color parameter
struct SeparatorDots: View {
    var blinking: Bool = false
    var second: Int = 0
    var color: Color = .dsAccent   // ← new, default preserves existing behavior

    var body: some View {
        VStack(spacing: 18) { ... }
        .foregroundStyle(color)    // ← was Color.dsAccent
        ...
    }
}

// ContentView call site — pass resolved color
SeparatorDots(
    blinking: settings.blinkingColon,
    second: second,
    color: settings.colonColor ?? .dsAccent   // ← new
)
```

**Acceptance criteria:**
- [ ] `SeparatorDots` has a `color: Color` parameter defaulting to `.dsAccent`
- [ ] `ContentView` passes `settings.colonColor ?? .dsAccent`
- [ ] Default behavior (nil colonColor) is visually unchanged — dots still appear orange
- [ ] Changing `settings.colonColor` reactively updates the displayed dot color

**Verification:** Build and run on simulator; verify dots are orange by default; set a colonColor in a debug breakpoint and confirm the dots update.

**Dependencies:** Task 2
**Size:** S

---

### Task 4: SettingsView — ColorPicker + reset

**Description:** Add a "Colon Color" row to the "Clock" section in `SettingsView`. Use SwiftUI's native `ColorPicker` for selection. Show a "Reset to Default" button that sets `colonColor` to `nil`, visible only when a custom color is active.

**Files touched:**
- `SimpleClock/SimpleClock/SettingsView.swift`

**UI structure:**
```swift
Section("Clock") {
    Toggle("Blinking Colon", isOn: $settings.blinkingColon)

    ColorPicker("Colon Color", selection: Binding(
        get: { settings.colonColor ?? .dsAccent },
        set: { settings.colonColor = $0 }
    ))

    if settings.colonColor != nil {
        Button("Reset to Default") {
            settings.colonColor = nil
        }
        .foregroundStyle(.secondary)
    }
}
```

**Acceptance criteria:**
- [ ] "Colon Color" `ColorPicker` row appears in the "Clock" section
- [ ] Picker defaults to showing `dsAccent` orange when no custom color is set
- [ ] Selecting a color updates the colon in real time (reactive via `@EnvironmentObject`)
- [ ] "Reset to Default" button appears only when `colonColor != nil`
- [ ] Tapping "Reset to Default" restores the orange accent and hides the button
- [ ] Color persists across app restarts

**Verification:** Run on simulator; open settings; change colon color; close and reopen app; confirm color persists; tap reset and confirm orange is restored.

**Dependencies:** Tasks 2, 3
**Size:** S

---

### Task 5: Tests — AppSettings colonColor persistence

**Description:** Add unit tests to `SimpleClockTests.swift` covering the `colonColor` property round-trip through UserDefaults.

**Files touched:**
- `SimpleClock/SimpleClockTests/SimpleClockTests.swift`

**Test cases:**
1. Default init → `colonColor` is `nil`
2. Set a color → RGBA components written to UserDefaults
3. Re-init from same UserDefaults → `colonColor` is non-nil and resolves to the same color
4. Set `colonColor = nil` → key removed from UserDefaults; re-init gives `nil`

**Acceptance criteria:**
- [ ] All 4 test cases pass
- [ ] Tests use an in-memory `UserDefaults(suiteName:)` instance (not `.standard`) to avoid side effects

**Verification:** `Cmd+U` in Xcode; all tests green.

**Dependencies:** Task 2
**Size:** S

---

## Checkpoints

```
[Task 1] → CHECKPOINT A: SimpleClock.pen updated; color picker design approved

[Tasks 2-3] → CHECKPOINT B: App builds cleanly; colon color is data-driven;
              default behavior unchanged

[Task 4] → CHECKPOINT C: Full settings flow works end-to-end; color persists
           across launches; reset works correctly

[Task 5] → CHECKPOINT D: All unit tests pass; no regressions
```

---

## Risk Notes

- **ColorPicker color space**: SwiftUI `ColorPicker` returns a `Color` in the display P3 or sRGB color space depending on device. The RGBA component extraction via `UIColor.cgColor.components` may yield unexpected values outside sRGB gamut. For simplicity, this is acceptable — wide gamut colors will round-trip correctly on the same device.
- **nil comparison**: `Color` doesn't conform to `Equatable` in a way that allows direct nil comparison across color spaces. The `colonColor != nil` check in SettingsView is comparing the Optional wrapper, not Color values — this is safe.
- **Existing tests**: `SimpleClockTests.swift` currently has placeholder tests; adding new tests should not break existing ones.
