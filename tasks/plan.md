# Plan: App Icon Redesign

**Spec:** `SPEC.md`
**Output:** `tasks/todo.md`
**Status:** Ready for implementation

---

## Codebase Analysis

### Existing state

| File | Role | Relevant notes |
|------|------|----------------|
| `AppIcon.appiconset/Contents.json` | Asset catalog manifest | Slots for universal, dark, tinted — only `AppIcon-1024.png` (light) has a filename; dark and tinted have no `filename` key |
| `AppIcon.appiconset/AppIcon-1024.png` | Current icon | Placeholder; will be replaced |
| `DesignTokens.swift` | Design tokens | Colors referenced for palette |
| `scripts/` | Does not exist yet | Must be created |
| `SimpleClock.pen` | Design source | Icon artboards must be added here before build |

### Key constraints

- iOS 16+ requires only a single 1024×1024 universal PNG per variant — no per-size assets needed
- Generator is a standalone `swift` CLI script using CoreGraphics + CoreText + Foundation + ImageIO
- Three output filenames: `AppIcon-1024-light.png`, `AppIcon-1024-dark.png`, `AppIcon-1024-tinted.png`
- `Contents.json` must be updated to reference all three filenames

---

## Dependency Graph

```
Task 1: Icon artboards in SimpleClock.pen  (design — must come first per workflow)
    ↓
Task 2: Generator script + asset catalog   (scripts/generate-icon.swift + Contents.json)
    ↓
CHECKPOINT: Run script → 3 PNGs in asset catalog → verify in Xcode
```

---

## Tasks

---

### Task 1: Icon artboards in SimpleClock.pen (DESIGN — manual step)

**Description:** Add three icon artboards to `SimpleClock.pen` before any code is written. Each shows the digital time "10:10" on a flat background — the exact visual the generator will produce.

**Files touched:**
- `SimpleClock.pen` — add three artboards to the components lane

**Artboard contents:**
- Flat background fill (per variant color)
- "10:10" in system ultralight font, large, left-aligned with ~8% left padding, vertically centered
- Nothing else

**Acceptance criteria:**
- [ ] Three artboards: "Icon — Light", "Icon — Dark", "Icon — Tinted" — each 1024×1024
- [ ] Light: `#FAFAFA` background, `#1A1A1A` text
- [ ] Dark: `#0F0F0F` background, `#F5F5F5` text
- [ ] Tinted: `#F0F0F0` background, `#505050` text
- [ ] No additional graphical elements

**Verification:** Open SimpleClock.pen and review all three artboards.

**Dependencies:** None
**Size:** S (design only)

---

### Task 2: Generator script + asset catalog wiring

**Description:** Write `scripts/generate-icon.swift` — a standalone CoreText/CoreGraphics script that renders the digital time in three color variants and writes PNGs to the asset catalog. Update `Contents.json` to reference all three files.

**Files touched:**
- `scripts/generate-icon.swift` — new file
- `SimpleClock/SimpleClock/Assets.xcassets/AppIcon.appiconset/Contents.json` — add `filename` to all three entries
- `SimpleClock/SimpleClock/Assets.xcassets/AppIcon.appiconset/AppIcon-1024-light.png` — generated
- `SimpleClock/SimpleClock/Assets.xcassets/AppIcon.appiconset/AppIcon-1024-dark.png` — generated
- `SimpleClock/SimpleClock/Assets.xcassets/AppIcon.appiconset/AppIcon-1024-tinted.png` — generated

**Rendering approach:**
- 1024×1024 bitmap `CGContext`
- Background: fill full rect with variant color
- Font: `CTFontCreateWithName("HelveticaNeue-UltraLight", fontSize, nil)` — ultralight, scaled to fit "10:10" at ~80% canvas width (~820px target)
- Text position: left edge ~80px from left, baseline vertically centered
- Draw via `CTLineDraw` into CGContext
- Export PNG via `CGImageDestination` (ImageIO)

**Acceptance criteria:**
- [ ] `swift scripts/generate-icon.swift` from repo root produces three PNGs in the asset catalog
- [ ] Script is idempotent — re-running overwrites without error
- [ ] Each PNG is exactly 1024×1024
- [ ] Light: `#FAFAFA` bg, `#1A1A1A` text
- [ ] Dark: `#0F0F0F` bg, `#F5F5F5` text
- [ ] Tinted: `#F0F0F0` bg, `#505050` text
- [ ] `Contents.json` has `filename` for all three image entries
- [ ] Old `AppIcon-1024.png` is removed

**Verification:** Run script → inspect PNGs → open Xcode → verify in asset catalog preview → run on simulator and confirm home screen icon.

**Dependencies:** Task 1
**Size:** M

---

## Checkpoints

```
[Task 1] → CHECKPOINT A: Three artboards reviewed in SimpleClock.pen; design approved

[Task 2] → CHECKPOINT B: Script runs cleanly; 3 PNGs generated; Contents.json fully wired;
           icon renders correctly on simulator home screen
```

---

## Risk Notes

- **Font availability**: `HelveticaNeue-UltraLight` is reliably available on macOS. If unavailable, fall back to `CTFontCreateUIFontForLanguage(.system, size, nil)` with a thin trait.
- **CoreText CG coordinate system**: CG origin is bottom-left. Text baseline must be offset upward by the descent value. Use `CTLineGetTypographicBounds` to measure ascent/descent for precise centering.
- **Font size fitting**: measure "10:10" width at a starting size (e.g. 260pt), scale proportionally to hit the 820px target. Do this once at script startup.
- **Path resolution**: script resolves output path relative to `CommandLine.arguments[0]` → `../SimpleClock/SimpleClock/Assets.xcassets/AppIcon.appiconset/`.
- **Removing old PNG**: delete `AppIcon-1024.png` after generating the three new files to avoid a stale unreferenced asset.
