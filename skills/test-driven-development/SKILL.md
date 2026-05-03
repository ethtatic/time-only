---
name: test-driven-development
description: Write a failing test before writing the code that makes it pass. Tests are proof of functionality.
---

# Test-Driven Development

## Overview

"Write a failing test before writing the code that makes it pass." Tests serve as proof of functionality — intuition alone is insufficient.

## When to Use

- Implementing any new feature or behavior
- Fixing a bug (use the Prove-It pattern)
- Modifying existing behavior

## The TDD Cycle

```
RED   → Write a failing test
GREEN → Implement the minimal code to pass it
REFACTOR → Clean up while keeping tests green
```

Never skip RED. If you write the code first, you don't know whether your test actually validates the behavior.

## For New Features

1. Write a test describing the expected behavior (it **must fail** before any implementation)
2. Implement the minimal code to make the test pass
3. Refactor while keeping the test green

## The Prove-It Pattern (Bug Fixes)

Don't fix a bug without first proving it exists via a test:

1. Write a test that reproduces the bug — it **must fail**
2. Confirm the test fails as expected
3. Implement the fix
4. Confirm the test now passes
5. Run the full test suite for regressions

This provides concrete evidence the bug is fixed and guards against recurrence.

## Test Structure: Arrange-Act-Assert

```swift
func testTimeDisplayUpdatesEverySecond() {
    // Arrange
    let viewModel = ClockViewModel()
    let initialTime = viewModel.currentTime

    // Act
    viewModel.tick()

    // Assert
    XCTAssertNotEqual(viewModel.currentTime, initialTime)
}
```

## Test Naming

`[unit] [expected behavior] [condition]`

Examples:
- `testClockDisplaysCurrentTime`
- `testTimerFiresEverySecond`
- `testTimeFormatMatchesDeviceSettings`

## Test Pyramid

```
E2E tests (~5%)       ← Critical user flows only
Integration tests (~15%) ← Cross-boundary interactions
Unit tests (~80%)     ← Pure logic, isolated, fast
```

Small, fast unit tests should dominate the suite.

## Key Principles

- **Test outcomes, not interactions** — Assert on results, not on how code is called internally
- **DAMP over DRY** — Tests should read as specs; self-contained tests prove more valuable than shared helpers that obscure intent
- **Real implementations over mocks** — Order: real → fake → stub → mock. Over-mocking creates false confidence
- **Test at the lowest level possible** — If a unit test can cover it, don't use an integration test

## Anti-Patterns

- Writing the implementation before the test
- Tests that always pass (no RED phase)
- Mocking everything (including the thing under test)
- Testing implementation details instead of behavior
- Snapshot abuse as a substitute for meaningful assertions
- Shared mutable state between tests

## Red Flags

- "I'll write tests after" — Tests written after the fact test what the code does, not what it should do
- Tests that pass before the feature is implemented
- No test covers the bug that was just fixed
- Test suite passes but the feature doesn't work

## Verification

After implementing:

- [ ] A failing test existed before any implementation code was written
- [ ] The test now passes
- [ ] The full test suite passes (no regressions)
- [ ] The test name clearly describes what is being verified
- [ ] Test follows Arrange-Act-Assert structure
