# Blue Jay App Specification

## Core Concept

A habit-change weight loss app that focuses on replacing 1 specific "target bad food" with a proprietary "Blue Jay Combo" (healthy swap).

---

## Architecture

- **Stack:** iOS Native (SwiftUI)
- **Backend:** Firebase (Auth, Firestore for Combos)
- **Database:** Local SQLite (GRDB) for FNDDS food recall data
- **Monetization:** RevenueCat (Paywall on Tab 3)

---

## Tab Structure & Flow (3 Tabs)

### Tab 1: Recall (Input)

**Goal:** User logs 24-hour diet.

**UI Components:**
- Search bar (top)
- Recent Foods list (from SQLite/FNDDS)
- "Analyze" button (bottom)

**Logic:**
- Search local SQLite DB (FNDDS data)
- "Analyze" button navigates to Tab 2

**Exit Flow:**
- Popup asks: "Did you use a swap yesterday?"
- Save response
- Navigate to Tab 2

---

### Tab 2: Insights (Dashboard)

**Top Section - Weekly Focus:**
- Widget showing "This Week's Focus: [Food Name]"
- Progress indicator (swaps completed this week)
- CTA Button: "Find Swaps" → Goes to Tab 3

**Bottom Section - Daily Opportunities:**
- List of Top 3 unhealthy foods from yesterday's recall
- Each food has "Set as Focus" button (Target icon)
- Calorie impact preview

**Additional Features:**
- Quick check-in toggle: "I used a swap today"
- Current streak display
- Weekly stats summary

---

### Tab 3: Swaps (The Solution)

**Content:**
- List of proprietary Blue Jay Combos filtered by the current Focus Food
- If no focus set: Show most common problem foods

**Features:**
- "Go-To Swap" (Sticky at top, user's preferred swap)
- "See Other Swaps" link (expands full list)
- Each swap shows: Title, description, est. kcal drop
- **PAYWALL:** Locked content for free users

**Monetization:**
- Free: 1 swap visible (Go-To only)
- Premium: Full swap library access

**Actions:**
- Tap "Set as Go-To" to pin favorite swap
- Tap food name in swap to set as new focus

---

## Data Models

### Core Entities

```swift
// User's target food for the week
struct FocusFood {
    let id: UUID
    let foodName: String
    let weekStartDate: Date
    let targetCategory: String
    var swapCount: Int
}

// Food recall entry
struct RecallEntry {
    let id: UUID
    let date: Date
    let foodItems: [FoodItem]
    let usedSwap: Bool?
}

// FNDDS food item (local SQLite)
struct FoodItem {
    let fnddsId: String
    let description: String
    let calories: Double
    let category: String
}

// Blue Jay proprietary combo (Firebase)
struct BlueJayCombo {
    let id: String
    let title: String
    let description: String
    let targetFood: String
    let estKcalDrop: Int
    let isPremium: Bool
    let isGoTo: Bool // Sticky top position
}
```

---

## User Flow

### Onboarding
1. Welcome screen
2. Auth (Firebase)
3. Initial focus food selection
4. Explain the 3-tab system

### Daily Flow
1. **Morning:** Open app → Tab 1 (Recall yesterday)
2. **Recall Exit:** "Did you use a swap?" → Save
3. **Navigate to Tab 2:** See insights
4. **Weekly:** Review Tab 2 → Set new focus if needed
5. **When needed:** Tab 3 → Find swaps for focus food

### Weekly Flow
1. Monday: Set/confirm focus food
2. Daily: Log recall, track swaps
3. Sunday: Review progress, pick next week's focus

---

## Technical Requirements

### Local Database (SQLite + GRDB)
- **Purpose:** FNDDS food database for recall search
- **Size:** ~10MB (food descriptions, calories, categories)
- **Performance:** Fast typeahead search (<100ms)
- **Updates:** Ship with app, periodic updates

### Firebase Integration
- **Firestore Collections:**
  - `users/{userId}/recalls` - User recall history
  - `users/{userId}/focusFoods` - Weekly focus tracking
  - `combos` - Blue Jay swap library (global)
  
- **Auth:** Sign in with Apple, Google, Email
- **Security Rules:** User can only read/write own data

### RevenueCat Integration
- **Free Tier:**
  - Access to Tab 1, 2, 4
  - 1 swap visible on Tab 3
  - Basic insights
  
- **Premium Tier:**
  - Full swap library
  - Advanced insights
  - Custom combos (future)
  
- **Offerings:**
  - Monthly: $9.99
  - Annual: $79.99 (save 33%)

---

## UI/UX Guidelines

### Design Principles
1. **Simplicity:** One focus at a time
2. **Progress:** Clear visual feedback
3. **Actionable:** Every screen has a clear CTA
4. **Non-judgmental:** Positive reinforcement

### Color Scheme
- Primary: Blue Jay Blue (#4A90E2)
- Success: Green (#4CAF50)
- Warning: Amber (#FFC107)
- Background: Light gray (#F5F5F5)

### Typography
- Headers: SF Pro Display Bold
- Body: SF Pro Text Regular
- Data: SF Mono (for numbers)

---

## Navigation Flow (3 Tabs)

```
Tab 1 (Recall)
    ↓ [Analyze Button]
Tab 2 (Insights)
    ├─ [Find Swaps] → Tab 3
    └─ [Set as Focus] → Updates focus food state
Tab 3 (Swaps) 🔒 Paywall
    └─ [Set as Go-To] → Saves preferred swap
```

### Cross-Tab Actions
- Tab 1 → Tab 2: "Analyze" button (after logging recall)
- Tab 2 → Tab 3: "Find Swaps" button (for current focus)
- Tab 2: "Set as Focus" updates AppState focus food
- Tab 3: "Set as Go-To" saves user's preferred swap

---

## Analytics & Tracking

### Key Events
- `recall_completed` - User finished logging
- `swap_used_confirmed` - User confirmed swap usage
- `focus_food_set` - New weekly focus selected
- `swap_viewed` - User opened swap details
- `paywall_shown` - Paywall displayed
- `subscription_started` - User subscribed

### Metrics
- Daily Active Users (DAU)
- Recall completion rate
- Swap usage rate
- Paywall conversion rate
- Retention (D1, D7, D30)
- Average swaps per week

---

## MVP Scope (Phase 1)

### Must-Have
- [x] Basic tab structure (3 tabs)
- [ ] Tab 1: Search + Recall (local SQLite)
- [ ] Tab 2: Insights dashboard (focus tracking + top 3 foods)
- [ ] Tab 3: Swap list with paywall
- [ ] Firebase Auth
- [ ] RevenueCat integration
- [ ] Basic analytics

### Nice-to-Have (Phase 2)
- [ ] Advanced insights (charts, trends)
- [ ] Custom combos
- [ ] Social features (share swaps)
- [ ] Habit streaks
- [ ] Push notifications

### Future (Phase 3+)
- [ ] AI-powered food detection (photo)
- [ ] Nutrition coach chat
- [ ] Grocery list generation
- [ ] Recipe integration

---

## Technical Implementation Plan

### Step 1: Foundation
1. Set up Firebase project
2. Configure RevenueCat
3. Create data models
4. Set up local SQLite with FNDDS data

### Step 2: Core Features
1. **Tab 1:** Implement search + recall list
2. **Tab 2:** Build insights dashboard (with focus tracking integrated)
3. **Tab 3:** Create swap list + paywall

### Step 3: Integration
1. Wire AppState across tabs
2. Connect Firebase for persistence
3. Implement RevenueCat paywall
4. Add analytics events

### Step 4: Polish
1. Error handling
2. Loading states
3. Onboarding flow
4. App Store assets

---

## Dependencies & Libraries

### Required Packages
- **GRDB.swift** - SQLite database
- **Firebase** (Auth, Firestore, Analytics)
- **RevenueCat** - In-app purchases
- **SwiftUI** (native, no external UI libs)

### Optional
- **Kingfisher** - Image caching (if adding photos)
- **SwiftLint** - Code quality

---

## Testing Strategy

### Unit Tests
- SwapEngine logic
- Food matching algorithms
- Calorie calculations

### Integration Tests
- Firebase CRUD operations
- SQLite queries
- RevenueCat subscription flow

### UI Tests
- Critical user flows (recall → insights → swaps)
- Paywall presentation
- Navigation between tabs

---

## Launch Checklist

### Pre-Launch
- [ ] App Store Connect setup
- [ ] Privacy policy page
- [ ] Terms of service
- [ ] App Store screenshots
- [ ] App Store description
- [ ] TestFlight beta testing
- [ ] Analytics verification

### Launch Day
- [ ] Submit to App Store
- [ ] Monitor crash reports
- [ ] Track key metrics
- [ ] Respond to reviews

### Post-Launch
- [ ] Collect user feedback
- [ ] Monitor conversion rates
- [ ] Iterate on paywall copy
- [ ] Plan feature updates

---

## Business Model

### Revenue Streams
1. **Primary:** Subscription (Premium tier)
2. **Future:** Partnerships with healthy food brands
3. **Future:** Meal kit integrations

### Pricing Strategy
- Free tier: Generate interest, prove value
- Premium tier: Unlock full swap library
- Annual discount: Encourage commitment

### Success Metrics
- Target: 10% conversion to premium
- Goal: $10 ARPU (Average Revenue Per User)
- Retention: 50% after 3 months

---

## Support & Documentation

### User Support
- In-app FAQ
- Email support: support@bluejayapp.com
- Video tutorials (YouTube)

### Developer Documentation
- README.md (setup instructions)
- CONTRIBUTING.md (code guidelines)
- API_DOCS.md (Firebase structure)

---

## Version History

### v1.0 (MVP)
- 4-tab structure
- Basic recall + insights
- Swap library with paywall
- Firebase + RevenueCat integration

### v1.1 (Planned)
- Enhanced insights with charts
- Push notifications
- Habit streaks

### v2.0 (Future)
- AI food detection
- Social features
- Custom combos

---

**Document Version:** 1.0  
**Last Updated:** November 25, 2025  
**Owner:** Cosmin Ionescu  
**Status:** Specification Complete, Implementation In Progress

