---
name: performance-optimization
description: Measure first — performance work without measurement is guessing.
---

# Performance Optimization

## Overview

"Performance work without measurement is guessing — and guessing leads to premature optimization that adds complexity without improving what matters."

## When to Optimize

- Users report slow behavior or Instruments shows a bottleneck
- A recent change caused measurable degradation
- Features handle large datasets or high-frequency updates
- Performance requirements exist in the spec

**When NOT to optimize:** Without empirical evidence of a problem. Premature optimization adds complexity without benefit.

## Workflow

```
Measure → Identify bottleneck → Fix → Measure again → Guard
```

Never skip measuring before AND after.

## iOS-Specific Performance Targets

| Metric | Target |
|--------|--------|
| App launch (cold) | < 400ms to first frame |
| Main thread frame time | < 16ms (60fps) |
| Memory (foreground) | < 50MB for simple apps |
| Battery | No unnecessary background activity |

## Common iOS Performance Issues

### Main Thread Blocking

```swift
// ❌ Blocks main thread
let data = try! Data(contentsOf: url)

// ✅ Async
Task {
    let (data, _) = try await URLSession.shared.data(from: url)
    await MainActor.run { self.imageData = data }
}
```

### Timer Efficiency

For a clock app updating every second:
- `Timer.publish(every: 1, on: .main, in: .common)` is correct
- Don't use shorter intervals than needed
- Invalidate timers when the view disappears

### SwiftUI Re-renders

- Keep `@State` and `@ObservableObject` changes minimal and targeted
- Use `equatable()` modifier for views that receive complex value types
- Profile with Xcode's SwiftUI View Body instrument

### Memory

- Use `weak` references in closures that capture `self`
- Instruments > Leaks to find retain cycles
- Large images: use `resizable()` + `.scaledToFit()` instead of loading full-resolution

## Profiling Tools

- **Xcode Instruments > Time Profiler** — Find CPU hotspots
- **Instruments > Allocations** — Find memory growth
- **Instruments > Leaks** — Find retain cycles
- **Xcode > Debug Navigator > Memory/CPU** — Real-time monitoring during development

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "This might be slow, let me optimize it" | Measure first. What you think is slow often isn't the bottleneck. |
| "I'll optimize it later" | Only if users report it. Don't carry optimization debt speculatively. |

## Red Flags

- Optimizing before measuring
- Adding complexity for hypothetical future scale
- Timer intervals shorter than the feature requires
- Network calls on the main thread
- Unretained closures capturing self strongly in long-lived objects

## Verification

- [ ] Performance measured before and after change
- [ ] Improvement is confirmed by measurement, not assumption
- [ ] No regressions in other metrics
- [ ] No added complexity without proportional performance gain
