# BlueJay Release Candidate Checklist

Release candidate: v1.0 (build 2)

## Automated Validation

- [x] Unit tests pass (`xcodebuild ... test`, sequential mode)
- [x] UI smoke tests pass for Recall -> Insights -> Swaps flow
- [x] Free-tier upsell boundary verified in UI test

## Core Product Loop Validation

- [x] Recall entries saved and analyzed
- [x] Insights reflects detected foods and weekly focus
- [x] Swaps tab shows go-to flow and premium locks
- [x] Swap usage can be logged and persisted
- [x] Recall exit asks "Did you use your Go-To swap yesterday?"

## Monetization Validation

- [x] RevenueCat key is now configuration-driven (Info.plist key)
- [x] Paywall has restore flow
- [x] Premium users have subscription management entry point
- [x] Terms and Privacy links point to app-owned URLs

## Persistence and State Validation

- [x] Stable swap identity resolves persisted go-to mismatch
- [x] Weekly swap counters reset at week boundary
- [x] Data clear path removes focus and detected IDs too

## Observability

- [x] Lightweight event tracking for core funnel events
- [x] Basic uncaught exception capture hook installed

## Manual Pre-Submission Pass (Required)

- [ ] Device test: purchase monthly, purchase annual, restore
- [ ] Device test: subscription management page
- [ ] Device test: offline launch/resume
- [ ] Device test: uninstall/reinstall restore flow
- [ ] Verify production RevenueCat key is set in Release build settings
- [ ] Confirm hosted pages exist at:
  - `https://bluejayapp.com/privacy-policy`
  - `https://bluejayapp.com/terms`
