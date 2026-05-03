# SPEC.md — App Icon Redesign

## Objective

Replace the existing placeholder app icon with a clean digital time display that directly mirrors the app's own aesthetic.
Target: iOS users browsing the App Store; the icon is immediately recognisable as a clock app, calm and modern.

Deliverables:
- Three 1024×1024 PNG exports (light, dark, tinted) placed in the existing `AppIcon.appiconset`
- Updated `Contents.json` referencing all three files
- Icon designs captured in `SimpleClock.pen` (components lane)
- A standalone CoreGraphics + CoreText generator script at `scripts/generate-icon.swift`

---

## Design

### Layout
- **Shape**: filled square — iOS clips to squircle automatically
- **Content**: hours digits + separator dots + minutes digits, centered on canvas — matching the app's clock face layout exactly
- **Font**: system ultralight — same as app's `dsDisplay` (96pt scaled proportionally to canvas)
- **Separator**: two circles stacked vertically, matching the app's `SeparatorDots` component (8×8pt, 18pt gap, orange accent)
- **No additional elements** — background, digits, and separator dots only

### Color palette per variant

| Slot | Light | Dark | Tinted |
|------|-------|------|--------|
| Background | `#FAFAFA` | `#0F0F0F` | `#F0F0F0` |
| Digits | `#1A1A1A` | `#F5F5F5` | `#505050` |
| Separator dots | `#FF6B35` | `#FF6B35` | `#505050` |

Tinted uses no orange — grayscale only, for iOS 18+ adaptive tinted icon mode.

### Text sizing and position
- Font size: scaled proportionally from the app's 96pt on a 393pt-wide screen to the 1024px canvas
- Target: full layout (HH + gap + dots + gap + MM) fills ~80% of canvas width (≈819px)
- Scale factor derived at runtime: `scale = (1024 × 0.80) / appTotalWidth`
- All measurements scale together: font size, gaps, dot size, dot gap
- Layout centered both horizontally and vertically on the canvas

---

## Commands

```bash
# Generate all three icon PNGs and place them in the asset catalog
swift scripts/generate-icon.swift

# Verify files exist
ls SimpleClock/SimpleClock/Assets.xcassets/AppIcon.appiconset/
```

Build and run via Xcode to visually verify the icon on device/simulator.

---

## Project Structure

```
scripts/
  generate-icon.swift          # CoreGraphics + CoreText PNG generator — macOS CLI script

SimpleClock/SimpleClock/Assets.xcassets/AppIcon.appiconset/
  Contents.json                # Updated to reference all three PNGs
  AppIcon-1024-light.png       # Light variant
  AppIcon-1024-dark.png        # Dark variant
  AppIcon-1024-tinted.png      # Tinted / monochrome variant

SimpleClock.pen                # Icon artboards added to components lane
```

---

## Code Style

- Generator: plain Swift, CoreGraphics + CoreText + Foundation + ImageIO only — no SwiftUI, no AppKit
- Font created via `CTFontCreateWithName` — use system thin/ultralight
- Script is self-contained and idempotent (re-running overwrites existing PNGs)
- No side-effects beyond writing the three PNG files

---

## Testing Strategy

- **Visual**: open asset catalog in Xcode; confirm icon renders correctly at all sizes and on simulator home screen
- **File presence**: after running the script, all three PNGs exist and are non-zero bytes
- **Contents.json**: all three image entries have a `filename` key (no empty slots)
- No unit tests for the generator — it is a one-time build tool

---

## Boundaries

- **Always**: run `swift scripts/generate-icon.swift` to produce PNGs; never hand-craft PNG bytes
- **Always**: update `SimpleClock.pen` with icon designs before touching the generator script
- **Ask first**: changing the time digits shown (currently "10" and "10")
- **Ask first**: adding any graphical elements beyond background, digits, and separator dots
- **Never**: use strong or saturated colors beyond the orange accent (`#FF6B35`)
- **Never**: add per-size PNG variants — iOS 16+ requires only the 1024×1024 universal image
