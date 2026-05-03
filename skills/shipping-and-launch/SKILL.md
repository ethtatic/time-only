---
name: shipping-and-launch
description: Prepares production launches. Use when preparing to deploy to production or submit to the App Store.
---

# Shipping and Launch

## Overview

Ship with confidence. The goal is not just to deploy — it's to deploy safely, with a clear understanding of what success looks like. Every launch should be reversible, observable, and incremental.

## When to Use

- Submitting to the App Store for the first time
- Releasing an update to users
- Any deployment that carries risk (all of them)

## The Pre-Launch Checklist

### Code Quality

- [ ] All tests pass
- [ ] Build succeeds with no warnings
- [ ] No TODO comments that should be resolved before launch
- [ ] Error handling covers expected failure modes

### Security (iOS/App Store)

- [ ] No secrets or API keys committed to version control
- [ ] PrivacyInfo.xcprivacy present and accurate
- [ ] App Privacy questionnaire in App Store Connect matches actual data usage
- [ ] No undeclared API usage (camera, contacts, location, etc.)

### Performance

- [ ] App launches quickly on the oldest supported device
- [ ] No memory leaks (verified with Instruments)
- [ ] No main-thread blocking operations

### Accessibility

- [ ] VoiceOver can describe all visible UI elements
- [ ] Dynamic Type is respected (text scales with system font size)
- [ ] Color contrast meets WCAG 2.1 AA (4.5:1 for normal text)

### App Store Requirements

- [ ] App icon present (1024×1024, no alpha, no transparency)
- [ ] Screenshots provided for required device sizes
- [ ] Version and Build numbers set correctly
- [ ] iOS Deployment Target matches minimum supported version
- [ ] Bundle ID matches App Store Connect registration
- [ ] Signing team and provisioning profile configured
- [ ] PrivacyInfo.xcprivacy included in target

### Documentation

- [ ] App description and keywords written in App Store Connect
- [ ] What's New text written (for updates)
- [ ] Support URL configured

## Archive & Submit Workflow

```
1. Select "Any iOS Device (arm64)" as destination
2. Product > Archive
3. Organizer > Distribute App > App Store Connect > Upload
4. App Store Connect: attach build, set pricing, submit for review
```

## Rollback Strategy

For App Store apps, rollback means releasing the previous version as a new build:

```
Rollback Plan:
- Trigger: User-reported crashes spike, critical functionality broken
- Action: Archive and submit previous working version as new build number
- Time to rollback: ~1-3 days (App Store review)
- Prevention: Thorough testing before submission
```

## Post-Submit Monitoring

After submitting:
- [ ] Monitor App Store Connect for review status
- [ ] Check crash reports in Xcode Organizer after release
- [ ] Monitor App Store ratings for user feedback

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "It works on the simulator, it'll work on device" | Device and simulator differ (memory, GPU, sensor access). Test on device. |
| "I'll add the privacy manifest later" | Required since May 2024 — omitting causes rejection. Add it before submission. |
| "Screenshots can wait" | App Store Connect won't let you submit without required screenshots. |

## Red Flags

- Submitting without testing on a real device
- Missing PrivacyInfo.xcprivacy
- Bundle ID mismatch between Xcode and App Store Connect
- Submitting on a Friday without monitoring

## Verification

Before archiving:

- [ ] Pre-launch checklist completed
- [ ] Tested on physical device
- [ ] Version/Build numbers correct
- [ ] Signing configured

After upload:

- [ ] Build appears in App Store Connect as "Processing" then "Ready to Submit"
- [ ] All required metadata filled in
- [ ] Pricing set correctly
