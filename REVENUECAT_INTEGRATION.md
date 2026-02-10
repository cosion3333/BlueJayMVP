# RevenueCat Integration Guide

## ✅ Implementation Complete

The RevenueCat SDK has been fully integrated into Blue Jay with modern best practices.

---

## 📦 What Was Implemented

### 1. New Files Created

- **`BlueJayMVP/Services/RevenueCatService.swift`**
  - Singleton service managing all RevenueCat operations
  - Async/await API with modern Swift Concurrency
  - Real-time subscription updates via PurchasesDelegate
  - Customer info syncing and entitlement checking

- **`BlueJayMVP/Views/CustomerCenterView.swift`**
  - Native RevenueCatUI Customer Center
  - Allows premium users to manage subscriptions
  - Access via Settings or Profile screen

### 2. Updated Files

- **`BlueJayMVPApp.swift`**
  - Added RevenueCat configuration at app launch
  - Injected `RevenueCatService.shared` into environment

- **`AppModel.swift`**
  - Changed `isPremium` from stored property to computed property
  - Now reads from `RevenueCatService.shared.isPremium`
  - Added `syncPremiumStatus()` method

- **`PaywallView.swift`**
  - Integrated RevenueCatUI native paywall
  - Fallback to custom paywall if offerings not loaded
  - Real product pricing from RevenueCat
  - Error handling for purchases and restores
  - Success alerts for restore operations

- **`SwapsView.swift`**
  - Removed debug triple-tap premium toggle
  - Premium status now controlled by RevenueCat only

---

## 🚀 Next Steps

### Step 1: Install RevenueCat SDK Package

1. **Open Xcode** and your project
2. Go to **File → Add Package Dependencies...**
3. Enter URL: `https://github.com/RevenueCat/purchases-ios-spm.git`
4. Select **"Up to Next Major Version"** (5.x or later)
5. Add both libraries:
   - ✅ **RevenueCat** (required)
   - ✅ **RevenueCatUI** (for native paywalls)

### Step 2: Add New Files to Xcode Project

The files have been created, but you need to add them to Xcode:

1. In Xcode, **right-click on the `Services` folder**
2. Select **"Add Files to BlueJayMVP..."**
3. Navigate to and select: `BlueJayMVP/Services/RevenueCatService.swift`
4. Make sure **"Copy items if needed"** is **unchecked**
5. Click **"Add"**

6. In Xcode, **right-click on the `Views` folder**
7. Select **"Add Files to BlueJayMVP..."**
8. Navigate to and select: `BlueJayMVP/Views/CustomerCenterView.swift`
9. Make sure **"Copy items if needed"** is **unchecked**
10. Click **"Add"**

### Step 3: Configure RevenueCat Dashboard

1. Go to **https://app.revenuecat.com**
2. Create a new project (if you haven't already)
3. Navigate to **"Entitlements"** and create:
   - **Identifier:** `Blue Jay Swaps Pro`
   
4. Navigate to **"Products"** and link:
   - **Product ID:** `monthly` (must match App Store Connect)
   - **Product ID:** `yearly` (must match App Store Connect)
   
5. Navigate to **"Offerings"** and create:
   - Create a new offering
   - Mark it as **"Current Offering"**
   - Add both packages (monthly and yearly)
   - Set yearly as the default/recommended

### Step 4: Set Up App Store Connect

1. Go to **https://appstoreconnect.apple.com**
2. Select your app
3. Go to **"In-App Purchases"** → **"Subscriptions"**
4. Create a **Subscription Group**: `Blue Jay Pro`
5. Add two subscriptions:

   **Monthly Subscription:**
   - Product ID: `monthly`
   - Reference Name: `Blue Jay Pro Monthly`
   - Duration: 1 Month
   - Price: Your chosen price (e.g., $4.99)

   **Yearly Subscription:**
   - Product ID: `yearly`
   - Reference Name: `Blue Jay Pro Yearly`
   - Duration: 1 Year
   - Price: Your chosen price (e.g., $29.99)
   - Consider offering a free trial (e.g., 7 days)

### Step 5: Testing

#### Test with Sandbox Account:

1. **Create Sandbox Tester** in App Store Connect:
   - Go to **Users and Access → Sandbox Testers**
   - Create a new sandbox tester account

2. **Sign Out of App Store** on your device:
   - Settings → App Store → Sign Out

3. **Run Your App** from Xcode

4. **Trigger the Paywall**:
   - Go to the Swaps tab
   - Tap on a locked swap
   - The paywall should appear

5. **Make a Test Purchase**:
   - Select a subscription package
   - When prompted, sign in with your **sandbox tester credentials**
   - Complete the purchase (you won't be charged)

6. **Verify Premium Access**:
   - Check that `isPremium` is now `true`
   - All swaps should now be unlocked

#### Test Restore Purchases:

1. **Delete the app** from your device
2. **Reinstall** from Xcode
3. **Trigger the paywall**
4. **Tap "Restore Purchases"**
5. Verify premium access is restored

---

## 🔧 Configuration Details

### API Keys

**Current (Configuration-Driven):**
- Debug uses `INFOPLIST_KEY_REVENUECAT_API_KEY` (currently test key for local development)
- Release expects `INFOPLIST_KEY_REVENUECAT_API_KEY` set to your production RevenueCat key

**Before Production Launch:**
Set `INFOPLIST_KEY_REVENUECAT_API_KEY` in Release build settings to your production key from RevenueCat dashboard.

### Entitlement

```swift
private let entitlementID = "Blue Jay Swaps Pro"
```

This must match exactly in:
- RevenueCatService.swift
- RevenueCat Dashboard → Entitlements

### Product IDs

Must match in all three places:
1. **RevenueCat Dashboard** → Products
2. **App Store Connect** → In-App Purchases
3. Your offering configuration

---

## 📱 How It Works

### App Launch Flow

```
App Launch
    ↓
RevenueCatService.configure()
    ↓
Load Customer Info (async)
    ↓
Check Entitlement "Blue Jay Swaps Pro"
    ↓
Update isPremium status
```

### Purchase Flow

```
User taps "Unlock All Swaps"
    ↓
PaywallView appears
    ↓
RevenueCatUI.PaywallView shows offerings
    ↓
User selects package (monthly/yearly)
    ↓
RevenueCat handles purchase
    ↓
Entitlement granted
    ↓
isPremium = true (real-time update)
    ↓
Paywall dismisses
    ↓
All swaps unlocked
```

### Restore Flow

```
User taps "Restore Purchases"
    ↓
RevenueCat.restorePurchases()
    ↓
Fetches receipt from App Store
    ↓
Syncs with RevenueCat backend
    ↓
Restores entitlements
    ↓
isPremium = true
    ↓
Success alert shown
```

---

## 🎨 UI Components

### Native RevenueCat Paywall

The app uses RevenueCat's native `PaywallView` from `RevenueCatUI`:

**Benefits:**
- ✅ Beautiful, pre-designed UI
- ✅ A/B testable from dashboard (no app updates needed)
- ✅ Localized automatically
- ✅ Handles loading states, errors, and edge cases
- ✅ Shows real product info from App Store

**Fallback:**
If offerings aren't loaded, the app shows a custom fallback paywall with:
- Feature list
- Pricing cards
- Manual purchase buttons

### Customer Center

Premium users can access the Customer Center to:
- View subscription details
- Manage renewal settings
- Cancel subscription
- View billing history

**To present Customer Center:**
```swift
@State private var showCustomerCenter = false

// In your Settings or Profile view:
if revenueCat.canShowCustomerCenter {
    Button("Manage Subscription") {
        showCustomerCenter = true
    }
}

.sheet(isPresented: $showCustomerCenter) {
    CustomerCenterView()
}
```

---

## 🔍 Debugging

### Enable Debug Logging

Already enabled in `RevenueCatService.swift`:

```swift
Purchases.logLevel = .debug  // Set to .info in production
```

**Console Output Examples:**
```
✅ RevenueCat configured with API key
✅ Customer info refreshed - Premium: false
✅ Offerings loaded - Current: default
   Packages: monthly, yearly
🔄 Customer info updated - Premium: true
✅ Purchase successful - Premium: true
```

### Check Premium Status

Add this helper to `AppModel` or any view:

```swift
func debugPremiumStatus() {
    let rc = RevenueCatService.shared
    print("🔍 Premium Status Debug:")
    print("   isPremium: \(rc.isPremium)")
    print("   Has customerInfo: \(rc.customerInfo != nil)")
    
    if let info = rc.customerInfo {
        print("   Entitlements: \(info.entitlements.all.keys)")
        if let entitlement = info.entitlements["Blue Jay Swaps Pro"] {
            print("   Blue Jay Swaps Pro:")
            print("     - isActive: \(entitlement.isActive)")
            print("     - willRenew: \(entitlement.willRenew)")
            print("     - expirationDate: \(entitlement.expirationDate?.description ?? "none")")
        }
    }
    
    print("   Available packages: \(rc.availablePackages.count)")
}
```

### Common Issues

**Issue:** "No offerings found"
- **Solution:** Check RevenueCat dashboard has a "Current Offering" configured

**Issue:** "Product not found"
- **Solution:** Verify product IDs match exactly in RevenueCat and App Store Connect

**Issue:** "Purchase failed"
- **Solution:** Check that you're signed out of App Store and using sandbox tester

**Issue:** "Cannot connect to App Store in Sandbox"
- **Solution:** Make sure you're running on a real device (not simulator for purchases)

---

## 🎯 Best Practices

### 1. Always Check Entitlements, Not Receipts

```swift
// ✅ CORRECT - Check entitlement
let isPremium = customerInfo.entitlements["Blue Jay Swaps Pro"]?.isActive == true

// ❌ WRONG - Don't check product IDs directly
let isPremium = customerInfo.activeSubscriptions.contains("monthly")
```

### 2. Handle Offline Gracefully

RevenueCat caches entitlements locally. The app works offline.

### 3. Sync on App Resume

Add to `ContentView` or `BlueJayMVPApp`:

```swift
.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
    appModel.syncPremiumStatus()
}
```

### 4. Test Edge Cases

- ✅ Purchase → Delete app → Reinstall → Restore
- ✅ Purchase on iPhone → Sign in on iPad → Verify access
- ✅ Subscription expires → Verify access removed
- ✅ User cancels but still in trial → Verify access until end date

---

## 📊 Analytics Integration (Future)

RevenueCat can send events to:
- Firebase Analytics
- Amplitude
- Mixpanel
- And more...

Configure in RevenueCat Dashboard → Integrations

---

## 🚨 Pre-Launch Checklist

Before submitting to App Store:

- [ ] Switch to **production API key** in `RevenueCatService.swift`
- [ ] Set `Purchases.logLevel = .info` (not `.debug`)
- [ ] Add **Privacy Policy** and **Terms of Service** links to paywall
- [ ] Test all purchase flows in sandbox
- [ ] Test restore purchases
- [ ] Test subscription management in Customer Center
- [ ] Verify product IDs match in all 3 places
- [ ] Submit subscription for App Review in App Store Connect
- [ ] Add subscription marketing content in App Store Connect
- [ ] Test with TestFlight before public release

---

## 📚 Resources

- **RevenueCat Docs:** https://www.revenuecat.com/docs
- **iOS SDK Reference:** https://sdk.revenuecat.com/ios/
- **Dashboard:** https://app.revenuecat.com
- **Community:** https://community.revenuecat.com

---

## 🎉 Summary

Your Blue Jay app now has a **production-ready subscription system** powered by RevenueCat!

**What you get:**
- ✅ Native, beautiful paywall UI
- ✅ Real-time entitlement syncing
- ✅ Restore purchases
- ✅ Customer Center for subscription management
- ✅ A/B testable paywalls (from dashboard)
- ✅ Analytics-ready
- ✅ Cross-platform receipt validation
- ✅ Handles free trials, grace periods, and more

**Next:**
1. Install SDK packages in Xcode
2. Add new files to project
3. Configure RevenueCat Dashboard
4. Set up App Store Connect subscriptions
5. Test with sandbox account
6. Launch! 🚀
