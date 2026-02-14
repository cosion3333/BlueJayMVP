# BlueJay MVP — App Store Launch Plan

Single source of truth for every step needed to ship v1.0 to the iOS App Store.
Check items off as you go. Any AI agent working on this project should reference this file.

> **Related docs:**
> - [BLUEJAY_SPEC.md](BLUEJAY_SPEC.md) — Product spec & core loop
> - [GO_TO_MARKET.md](GO_TO_MARKET.md) — Pricing, marketing, paywall strategy
> - [REVENUECAT_INTEGRATION.md](REVENUECAT_INTEGRATION.md) — RevenueCat setup details
> - [GOLDEN_PATH_TESTING.md](GOLDEN_PATH_TESTING.md) — QA test script

---

## Current State (as of 2025-02-14)

- **Core app**: All 3 tabs implemented and functional (Recall, Insights, Swaps)
- **Core loop works**: Recall → Focus → Go-To Swap → Track Usage
- **RevenueCat**: SDK integrated, paywall/purchase/restore flows wired, entitlement checks in place
- **Content**: 40 bad foods + 120 swaps bundled in `bluejay_data.json`
- **Persistence**: UserDefaults (local only, no backend)
- **Auth**: None — shipping without login (see Deferred to v1.1 section below)
- **StoreKit config**: Products defined (`com.bluejay.premium.monthly` $9.99, `com.bluejay.premium.annual` $59.99)
- **Bundle ID**: `Orion.BlueJayMVP`
- **Team ID**: `V7KVJ3ZRT8`

---

## Phase 1: Code Cleanup & Production Config

> Estimated effort: 1–2 hours (blocked on Phase 2B for the production API key)

- [ ] **1.1** Replace RevenueCat test API key with production key
  - File: `BlueJayMVP/Services/RevenueCatService.swift` line 18
  - Replace `test_DWbLlQNWFHLimjMuupRGeegPNlL` with the production Apple API key from RevenueCat dashboard (created in step 2B.7)

- [x] **1.2** Change RevenueCat log level to `.info`
  - File: `BlueJayMVP/Services/RevenueCatService.swift`
  - Changed `Purchases.logLevel = .debug` → `.info` ✅

- [x] **1.3** Fix `CustomerCenterView` recursive call
  - Renamed to `CustomerCenterWrapper` to avoid name collision
  - Now correctly calls `RevenueCatUI.CustomerCenterView()` ✅

- [x] **1.4** Remove unused `CheckInView`
  - Deleted `BlueJayMVP/Views/CheckInView.swift` ✅
  - AppModel properties (currentStreak, etc.) kept — still used by InsightsView

- [x] **1.5** Decide on deployment target
  - Changed from iOS 17.6 → iOS 17.0 (all targets including test targets) ✅
  - Supports iPhone XS (2018) and newer, ~85-90% of active iPhones

- [ ] **1.6** Wire Privacy Policy & Terms URLs in-app
  - Update `PaywallView.swift` with the real hosted URLs (created in Phase 3)

---

## Phase 2A: App Store Connect Setup

> Estimated effort: 1–2 hours | Requires: Apple Developer Program membership

- [ ] **2A.1** Sign in to [App Store Connect](https://appstoreconnect.apple.com)

- [ ] **2A.2** Create a new app record
  - Platform: iOS
  - Name: "BlueJay" (or chosen name — check availability)
  - Bundle ID: `Orion.BlueJayMVP`
  - SKU: `bluejay-mvp`
  - Primary language: English (U.S.)

- [ ] **2A.3** Create a Subscription Group: "BlueJay Premium"

- [ ] **2A.4** Add subscription product: Monthly
  - Product ID: `com.bluejay.premium.monthly`
  - Price: $9.99/month
  - Display name & description

- [ ] **2A.5** Add subscription product: Annual
  - Product ID: `com.bluejay.premium.annual`
  - Price: $59.99/year
  - Free trial: ______ (7 days recommended per GO_TO_MARKET.md)
  - Display name & description

- [ ] **2A.6** Set territory availability: United States only

- [ ] **2A.7** Generate a Shared Secret (for RevenueCat, used in step 2B.2)

---

## Phase 2B: RevenueCat Dashboard Setup

> Estimated effort: 1 hour | Can be done in parallel with Phase 2A

- [ ] **2B.1** Create a new app in RevenueCat dashboard (Apple platform)

- [ ] **2B.2** Enter the App Store Connect shared secret (from step 2A.7)

- [ ] **2B.3** Create entitlement: `Blue Jay Swaps Pro`

- [ ] **2B.4** Create product: `com.bluejay.premium.monthly` — attach to entitlement

- [ ] **2B.5** Create product: `com.bluejay.premium.annual` — attach to entitlement

- [ ] **2B.6** Create an Offering, mark as "Current", add both products as packages

- [ ] **2B.7** Copy the **production Apple API key** — this goes into step 1.1

---

## Phase 3: Legal Pages

> Estimated effort: 1–2 hours

App Store Review requires a Privacy Policy URL. Terms of Service is strongly recommended.

- [ ] **3.1** Write a Privacy Policy
  - What to include: the app stores food logs locally on-device only; RevenueCat processes purchase data; no personal data is collected or shared; no account/login required
  - Keep it simple and honest

- [ ] **3.2** Write Terms of Service
  - What to include: subscription auto-renewal terms, cancellation via Apple settings, no refund through the app (handled by Apple), limitation of liability
  - Can use a standard template adapted for your app

- [ ] **3.3** Host both pages at stable URLs
  - Options: GitHub Pages, Notion public page, simple HTML on any static host
  - Privacy Policy URL: ______________________
  - Terms of Service URL: ______________________

- [ ] **3.4** Add URLs to App Store Connect (app metadata section)

- [ ] **3.5** Wire URLs in-app (step 1.6 above)

---

## Phase 4: App Store Assets

> Estimated effort: 3–5 hours

### App Icon

- [ ] **4.1** Design or finalize the app icon (1024x1024 PNG, no transparency, no rounded corners)

- [ ] **4.2** Add icon to `BlueJayMVP/Resources/Assets.xcassets/AppIcon.appiconset/`
  - The asset catalog is configured but currently has no image files

### Screenshots

- [ ] **4.3** Capture screenshots for required device sizes:
  - 6.7" display (iPhone 15 Pro Max) — **required**
  - 6.5" display (iPhone 11 Pro Max) — **required**
  - 5.5" display (iPhone 8 Plus) — optional but recommended

- [ ] **4.4** Prepare 3–5 screenshots showing:
  1. Recall tab — food logging
  2. Insights tab — weekly focus selection
  3. Swaps tab — swap combos (show the value)
  4. Paywall — what premium unlocks
  5. (Optional) Progress/win state

- [ ] **4.5** (Optional) Add device frames and marketing text overlays
  - Tools: Fastlane Frameit, Screenshots Pro, Figma templates

### Store Listing

- [ ] **4.6** Write App Store listing copy:
  - App name (30 chars max): ______________________
  - Subtitle (30 chars max): ______________________
  - Description (up to 4000 chars): ______________________
  - Keywords (100 chars max, comma-separated): ______________________
  - Category: Health & Fitness
  - Promotional text (can update without new build): ______________________
  - What's New: ______________________

- [ ] **4.7** Set Support URL: ______________________

- [ ] **4.8** Set Marketing URL (optional): ______________________

---

## Phase 5: Testing

> Estimated effort: 2–4 hours | Requires: Phases 1–4 complete

### Sandbox Purchase Testing

- [ ] **5.1** Create a Sandbox Tester account in App Store Connect

- [ ] **5.2** Test purchase flow:
  - View paywall → purchase monthly → verify premium unlocks → swaps accessible
  - View paywall → purchase annual → verify premium unlocks
  - Test free trial flow (if configured)

- [ ] **5.3** Test restore flow:
  - Delete app → reinstall → restore purchases → verify premium restored

- [ ] **5.4** Test cancellation/expiry:
  - Cancel subscription in sandbox → verify premium revokes after period ends

### TestFlight

- [ ] **5.5** Archive the app in Xcode → upload to App Store Connect

- [ ] **5.6** Add internal testers → install via TestFlight

- [ ] **5.7** Run the full golden path on a real device (per GOLDEN_PATH_TESTING.md):
  - Fresh install → log food → see opportunities → set weekly focus → view swaps → hit paywall → purchase → use swap → track usage

- [ ] **5.8** Test edge cases:
  - No internet at launch
  - Kill and relaunch app (state persistence)
  - Switch between tabs rapidly
  - Empty states (no food logged yet, no focus set)

### Optional: External TestFlight

- [ ] **5.9** (Optional) Submit for external TestFlight beta review (24–48h turnaround)
- [ ] **5.10** (Optional) Invite a small group of beta testers

---

## Phase 6: Submit for App Review

> Estimated effort: 1 hour active + 24–48h review wait

### Pre-Submission Checklist

- [ ] **6.1** Version set to 1.0, build number incremented from any TestFlight builds
- [ ] **6.2** All App Store Connect metadata filled in (description, screenshots, URLs)
- [ ] **6.3** Privacy Policy URL entered
- [ ] **6.4** Age rating questionnaire completed
- [ ] **6.5** App Review notes written:
  - Explain how to test the subscription (sandbox account credentials if needed)
  - Note that the app is US-only
  - Describe what premium unlocks

### Submit

- [ ] **6.6** Select the build in App Store Connect → Submit for Review

- [ ] **6.7** Monitor review status (typical: 24–48 hours, can be longer for first submission)

### Common Rejection Reasons to Preempt

- [ ] Missing restore purchases button — **already implemented**
- [ ] Missing subscription auto-renewal disclosure on paywall — **verify this is present**
- [ ] Broken Privacy Policy / Terms URLs — **test before submitting**
- [ ] Subscription not clearly described — **verify paywall copy is clear**

---

## Phase 7: Post-Launch

- [ ] **7.1** Release (manual or auto-release after approval)
- [ ] **7.2** Verify live App Store listing looks correct
- [ ] **7.3** Monitor RevenueCat dashboard for first purchases
- [ ] **7.4** Begin weekly results tracking in GO_TO_MARKET.md
- [ ] **7.5** Plan v1.1 fast-follows (see "Deferred to v1.1" section):
  - Firebase Auth (Sign in with Apple) + Firestore cloud sync
  - Onboarding flow (3–4 screens)
  - "Did you use a swap?" check-in popup
  - Analytics / crash reporting (TelemetryDeck or Firebase)
  - Iterate paywall copy based on conversion data

---

## Deferred to v1.1

The following features were **consciously deferred** to ship v1.0 faster. The core product loop works without them.

| Feature | Why It's OK to Skip for v1.0 | v1.1 Plan |
|---------|------------------------------|-----------|
| **Sign-in / Auth** | Apple only requires Sign in with Apple if you offer other social logins. No login = zero friction from download to first use. RevenueCat ties subscriptions to Apple ID, so purchases restore fine without our own auth. | Add Firebase Auth (Sign in with Apple) if retention data justifies it. |
| **Cloud sync (Firebase/Firestore)** | Data lives in UserDefaults locally. Risk: data lost if app deleted. Acceptable for launch — most users won't delete in week one. | Add Firestore sync so user data persists across devices/reinstalls. Consider iCloud Key-Value Storage as a quick interim solution. |
| **Onboarding flow** | The 3-tab structure is self-explanatory. Can add later when we see where users drop off. | Add 3–4 screen onboarding (welcome, first recall, focus explanation, tab tour). |
| **"Did you use a swap?" popup** | Engagement driver from the spec but not blocking core loop. | Add check-in popup on Tab 1 exit to boost swap tracking. |
| **Analytics / crash reporting** | RevenueCat provides purchase funnel data. Flying blind on in-app behavior is acceptable for initial launch. | Add Firebase Analytics or TelemetryDeck + crash reporting. |
| **FNDDS food database (SQLite)** | Current JSON keyword matching works. FNDDS typeahead search is a polish feature. | Evaluate if users struggle with food entry before investing. |

---

## Assumptions

- **Bundle ID**: Shipping with `Orion.BlueJayMVP`. If you want to change it, do so before creating anything in App Store Connect.
- **Pricing**: Using $9.99/month + $59.99/year (matches current StoreKit config and GO_TO_MARKET.md "aggressive" option).
- **Login**: No login for v1.0. No Firebase dependency. Subscriptions managed entirely by RevenueCat + Apple ID. This means no Sign in with Apple requirement from Apple's review guidelines.
- **Data risk**: User data is local-only (UserDefaults). If the app is deleted, data is lost. This is accepted for v1.0.

---

## Timeline Estimate

| Phase | Effort | Depends On |
|-------|--------|------------|
| Phase 1: Code cleanup | 1–2 hours | Phase 2B (for API key) |
| Phase 2A: App Store Connect | 1–2 hours | Developer account |
| Phase 2B: RevenueCat dashboard | 1 hour | Phase 2A (shared secret) |
| Phase 3: Legal pages | 1–2 hours | Hosting |
| Phase 4: Assets | 3–5 hours | Icon design |
| Phase 5: Testing | 2–4 hours | Phases 1–4 |
| Phase 6: Submission | 1 hour + 24–48h review | Phase 5 |
| Phase 7: Post-launch | Ongoing | Phase 6 |

**Total active work: ~10–16 hours**
