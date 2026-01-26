# BlueJay MVP – Go-To-Market

This doc is the single source of truth for how we ship + sell the MVP.
Keep it short, opinionated, and updated weekly.

---

## Goals (next 30/60/90 days)

- **30d**: Ship to App Store with RevenueCat paywall live; baseline funnel metrics (installs → paywall → trial → paid).
- **60d**: Iterate paywall + onboarding; grow steady organic content cadence; improve trial start and trial-to-paid.
- **90d**: Prove repeatable acquisition loop (organic + small paid) and consistent monthly subscriber adds.

---

## Market & platform

- **Market**: United States (US-only)
- **Platform**: iOS-only

---

## Target user + positioning

- **Primary persona**: Busy people who want healthier eating without calorie tracking or meal plans.
- **Main pain**: “I keep defaulting to the same bad foods (soda/chips/fast food) and I can’t stick to changes.”
- **One-sentence promise**: “Pick one weekly focus and get a go-to swap combo you can actually repeat.”
- **Differentiation**:
  - One focus at a time (reduces overwhelm)
  - Swap *combos* (feels like a trade, not restriction)
  - Fast daily loop (low effort)

---

## Product packaging (free vs premium)

Aligned to `BLUEJAY_SPEC.md` core loop: Recall → Focus → Go-To Swap → Track Usage → Win.

- **Free**:
  - Recall + Insights
  - Weekly Focus selection
  - Swaps: see Go-To swap only (or limited preview)
- **Premium (subscription)**:
  - Full swap library (“Other Swaps”) for current focus
  - More personalized recommendations as we expand content/logic

**Current implementation status**
- Paywall UI exists; premium is stubbed via `AppModel.isPremium` (to be replaced by RevenueCat entitlement).
- Swaps are already gated in `SwapsView` based on `isPremium`.

---

## Pricing & packaging

### Initial recommendation (MVP)
- **Monthly**: $14.99/month
- **Annual**: $79.99/year (=$6.67/mo; “save ~55%”)
- **Trial**: 7 days on annual (start with annual-only trial)

### Alternative (more aggressive conversion)
- **Monthly**: $9.99/month
- **Annual**: $59.99/year
- **Trial**: none initially (consider intro discount later)

### Decision (fill this in)
- **Market**: United States (US-only)
- **Platform**: iOS-only
- **Chosen monthly**:
- **Chosen annual**:
- **Trial?**:
- **Why this choice**:

---

## Paywall strategy (MVP)

- **Where shown**: Swaps tab when user taps a locked swap card or “Unlock All Swaps”.
- **What must be on paywall** (App Review friendly):
  - price + billing period + trial details
  - auto-renewal disclosure + how to manage/cancel
  - restore purchases
  - Privacy Policy + Terms links (hosted URLs)
- **Paywall copy focus**:
  - “Unlock all swaps for your weekly focus”
  - emphasize repeatability: “one go-to you can do all week”

### Success metrics (weekly)
- **Paywall view rate**: paywall views / active users
- **Trial start rate**: trials / installs (or / paywall views)
- **Trial-to-paid**: paid / trials
- **Early churn**: cancellations in first 30 days

---

## Login / accounts (MVP decision)

**Recommendation: no login for v1.**

- Subscriptions can be sold and restored without login (Apple/RevenueCat handle purchase identity).
- Login adds friction and usually hurts conversion at MVP stage.
- Add Sign in with Apple later only if needed for cross-device sync or server-driven personalization.

Decision:
- **Login in v1?**: No

---

## UA plan ($100/month)

Goal is learning (message + creative), not scale.

### Budget split (initial)
- **$60/mo**: TikTok Spark Ads (boost best-performing organic)
- **$40/mo**: Instagram Reels boost

### Creatives to test (2–3 total)
- **A (soda)**: “If you drink soda daily, do this swap combo for 7 days…”
- **B (late-night snacks)**: “Stop late-night chips without willpower: my go-to swap…”
- **C (fast food breakfast)**: “Drive-thru breakfast swap that still feels like fast food…”

### Targeting
- US-only.
- Keep targeting simple (broad or one interest layer).

### Measurement plan
- Use separate App Store product page links per channel (TikTok vs IG).
- Track weekly:
  - spend
  - installs
  - paywall views
  - trials
  - paid
  - CPI + trial start rate + trial-to-paid

---

## Launch checklist (operational)

### RevenueCat + App Store Connect
- Create subscription group + products (monthly + annual) in App Store Connect
- Configure entitlement (e.g. `premium`) + offering in RevenueCat
- App wiring:
  - fetch offerings + display real prices
  - purchase + restore
  - entitlement-driven `isPremium` state

### App Store submission
- Privacy policy URL + Terms URL (and in-app links)
- App Store screenshots
- TestFlight (internal + external)
- Review notes (how to test subscription, if needed)

---

## Assumptions & experiments (keep current)

### Assumptions
- The “one weekly focus” framing increases activation vs general diet tracking.
- Showing locked “Other Swaps” drives paywall intent at the moment of value.
- Annual-first trial converts better than monthly trial for this category.

### Experiments (next 2 weeks)
- Test 2 paywall headlines (value vs urgency)
- Test annual-first vs monthly-first layout
- Test 2 creatives (soda vs late-night snacks)

---

## Weekly results log (append-only)

### Week of YYYY-MM-DD
- **Spend**: $
- **Installs**:
- **Paywall views**:
- **Trials started**:
- **Paid starts**:
- **CPI**:
- **Trial start rate**:
- **Trial-to-paid**:
- **Notes / learnings**:

