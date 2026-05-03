# SimpleClock — Claude Code Guide

## Project

iOS clock app displaying the current time centered on screen. SwiftUI, iOS 17+, paid app ($0.99).

- Bundle ID: `com.pennewiss.simpleclock`
- Language: Swift / SwiftUI
- Minimum deployment target: iOS 16.0

## Development Workflow

This project uses the [agent-skills](https://github.com/addyosmani/agent-skills) framework.
Slash commands are in `.claude/commands/`. Skills are in `skills/`.

| Command | When to use |
|---------|-------------|
| `/spec` | Before starting any new feature — clarify and document requirements |
| `/plan` | After spec — decompose into tasks, output `tasks/plan.md` + `tasks/todo.md` |
| _(design)_ | **Before build** — update `SimpleClock.pen` with new screens, components, and states |
| `/build` | After design — implement tasks incrementally with TDD |
| `/test` | Write failing tests first; use Prove-It pattern for bug fixes |
| `/review` | Five-axis review after build, before merge |
| `/code-simplify` | Reduce complexity without changing behavior |
| `/ship` | Pre-launch checklist before App Store submission |

## Key Conventions

- Build in thin vertical slices — implement, test, verify, commit, repeat
- Never write more than ~100 lines before running tests
- Commit each slice with a descriptive message explaining *why*
- Touch only what the current task requires — note but don't fix out-of-scope issues

## Ignored Directories

- `cowork/` — Claude Cowork research notes, not part of app source
- `_staged/` — Staged source files pending Xcode project creation
