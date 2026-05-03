# SPEC: Pencil.dev Design System Setup
<!-- Status: Implemented — design tokens live in DesignTokens.swift; ContentView uses them -->

## Objective

Establish Pencil.dev as the design source of truth for SimpleClock. All UI decisions (colors, typography, spacing, layout) are defined in `.pen` files and committed to the repo. The design file drives implementation — code conforms to the design, not the other way around.

### Goals

1. Document the existing clock face UI in a `.pen` design file
2. Create a simple, modern design system with reusable variables (colors, typography, spacing)
3. Set up a workflow where new screens are designed in Pencil first, then implemented in SwiftUI
4. Enable AI-assisted design iteration via Pencil's MCP integration

### Non-Goals

- No code generation from Pencil (SwiftUI is hand-written)
- No Xcode or VS Code/Cursor integration — desktop app only

## Workflow

1. **Design** — Open `SimpleClock.pen` in Pencil desktop app
2. **Iterate** — Use AI (Claude Code) via MCP to modify designs programmatically
3. **Implement** — Translate design specs into SwiftUI code, matching variables exactly
4. **Verify** — Compare running app against Pencil screenshots/specs

## Project Structure

```
simpleclock/
├── SimpleClock.pen              # Design source of truth
├── CLAUDE.md
├── SPEC.md
├── SimpleClock/                 # Xcode project
│   ├── SimpleClock/
│   │   ├── ContentView.swift
│   │   ├── SimpleClockApp.swift
│   │   └── ...
│   └── ...
├── .claude/commands/            # Slash commands
├── skills/                      # Agent skills
└── tasks/                       # Plan & todo outputs
```

## Design System

### Color Palette

| Token              | Light Mode | Dark Mode  | Usage                    |
|---------------------|-----------|------------|--------------------------|
| `color.background`  | `#FAFAFA` | `#0F0F0F`  | App background           |
| `color.surface`     | `#FFFFFF` | `#1A1A1A`  | Card/panel backgrounds   |
| `color.primary`     | `#1A1A1A` | `#F5F5F5`  | Primary text, clock digits |
| `color.secondary`   | `#8A8A8A` | `#6B6B6B`  | Secondary/muted text     |
| `color.accent`      | `#FF6B35` | `#FF6B35`  | Separator dots, highlights |
| `color.border`      | `#E5E5E5` | `#2A2A2A`  | Subtle borders/dividers  |

### Typography

| Token               | Value                        | Usage              |
|----------------------|------------------------------|--------------------|
| `type.display`       | System, 96pt, Ultralight     | Clock digits       |
| `type.title`         | System, 28pt, Light          | Screen titles      |
| `type.body`          | System, 17pt, Regular        | Body text          |
| `type.caption`       | System, 13pt, Regular        | Labels, metadata   |

### Spacing

| Token              | Value | Usage                        |
|--------------------|-------|------------------------------|
| `spacing.xs`       | 4     | Tight gaps                   |
| `spacing.sm`       | 8     | Element spacing              |
| `spacing.md`       | 16    | Section padding              |
| `spacing.lg`       | 24    | Group spacing                |
| `spacing.xl`       | 40    | Major section gaps           |

### Radii

| Token              | Value | Usage                        |
|--------------------|-------|------------------------------|
| `radius.sm`        | 8     | Small elements (buttons)     |
| `radius.md`        | 12    | Cards, panels                |
| `radius.lg`        | 20    | Large containers             |

## .pen File Structure

The `SimpleClock.pen` file will contain:

1. **Design variables** — All tokens above as Pencil variables with light/dark theme support
2. **Components** — Reusable elements (clock digit, separator dots, etc.)
3. **Screens** — Full-screen artboards:
   - Clock face (current main screen)
   - Future screens as designed

## Code Style

- Design tokens map to SwiftUI `Color` and `Font` extensions
- Colors referenced by token name, not hardcoded hex values
- Spacing values match design system exactly
- All new UI work must reference the `.pen` file for specs

## Testing Strategy

- Visual comparison: running app matches Pencil design
- Unit tests for time formatting logic (existing)
- UI tests verify layout accessibility identifiers

## Boundaries

### Always
- Commit `.pen` file changes alongside related code changes
- Design new screens in Pencil before implementing in SwiftUI
- Use design system variables — never hardcode colors or spacing

### Ask First
- Adding new design tokens (keep the system small)
- Changing existing token values (affects all screens)
- Adding new screens to the `.pen` file

### Never
- Implement UI that contradicts the `.pen` design
- Use colors or spacing not defined in the design system
- Delete or overwrite the `.pen` file without backup
