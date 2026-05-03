---
name: security-and-hardening
description: Security-first development. Treat every external input as hostile, every secret as sacred.
---

# Security and Hardening

## Overview

Treat every external input as hostile, every secret as sacred, and every authorization check as mandatory.

## Always Do (No Exceptions)

- Validate all external input at system boundaries
- Keep secrets out of source code and version control
- Use HTTPS for all external communication
- Apply appropriate data protection to sensitive stored data

## Ask First (Requires Approval)

- New network endpoints or external service integrations
- Storage of sensitive user data
- Changes to authentication or authorization logic
- File access beyond the app's sandbox

## Never Do

- Commit API keys, tokens, or credentials to version control
- Log sensitive user data
- Trust client-provided data without validation
- Use `eval()` or execute arbitrary strings as code

## iOS-Specific Security

### Data Storage

```swift
// Sensitive data → Keychain (not UserDefaults)
let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrAccount as String: "userToken",
    kSecValueData as String: tokenData,
    kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
]
```

### Network

- Use `URLSession` with certificate pinning for sensitive endpoints
- Validate server certificates — never disable ATS (App Transport Security)
- Don't log network request/response bodies containing sensitive data

### Privacy Manifest (PrivacyInfo.xcprivacy)

Required since May 2024. Must accurately declare:
- `NSPrivacyTracking` — whether the app tracks users
- `NSPrivacyTrackingDomains` — domains used for tracking
- `NSPrivacyCollectedDataTypes` — what data is collected
- `NSPrivacyAccessedAPITypes` — which privacy-sensitive APIs are used

Inaccurate declarations → App Store rejection.

### Entitlements

Only request entitlements the app actually needs. Each entitlement widens the attack surface and requires App Store justification.

## Security Review Checklist

Before any release:

- [ ] No secrets in source code (`git grep -i "secret\|apikey\|token\|password"`)
- [ ] PrivacyInfo.xcprivacy matches actual data usage
- [ ] App Privacy questionnaire in App Store Connect is accurate
- [ ] Network calls use HTTPS only
- [ ] Sensitive data stored in Keychain, not UserDefaults or files
- [ ] Entitlements are minimal and justified
- [ ] Third-party SDKs reviewed for data collection

## Red Flags

- API key hardcoded in source file
- Privacy manifest missing or incomplete
- App requesting permissions it doesn't use
- Sensitive data logged in release builds
- ATS exceptions without justification

## Verification

- [ ] `git grep` finds no hardcoded secrets
- [ ] PrivacyInfo.xcprivacy is present and accurate
- [ ] All requested permissions have usage descriptions in Info.plist
- [ ] No sensitive data in UserDefaults
