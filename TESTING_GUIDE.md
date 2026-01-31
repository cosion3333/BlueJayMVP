# RevenueCat Quick Testing Guide

## 🧪 Testing Checklist

### Before You Start
- ✅ RevenueCat SDK installed via SPM
- ✅ New files added to Xcode project
- ✅ App builds without errors
- ✅ Sandbox tester created in App Store Connect

---

## Test 1: First Launch & Offerings Load

### Expected Behavior:
```
Console Output:
✅ RevenueCat configured with API key
✅ Customer info refreshed - Premium: false
✅ Offerings loaded - Current: default
   Packages: monthly, yearly
```

### What to Check:
- [ ] No crashes on app launch
- [ ] Console shows successful configuration
- [ ] Offerings are loaded (check console)

---

## Test 2: Trigger Paywall

### Steps:
1. Open app
2. Go to **Swaps** tab
3. Tap on any **locked swap** (grayed out with lock icon)
4. Paywall should appear

### Expected Behavior:
- [ ] Paywall appears with close button (X)
- [ ] Shows RevenueCat native paywall OR custom fallback
- [ ] Displays actual product info (if offerings loaded)
- [ ] Shows "Restore Purchases" button
- [ ] Shows Terms and Privacy links

### Console Output:
```
🔒 Paywall triggered
```

---

## Test 3: Purchase Flow (Sandbox)

### Prerequisites:
- Sign out of App Store on device (Settings → App Store)
- Have sandbox tester credentials ready

### Steps:
1. Trigger paywall (see Test 2)
2. Select **yearly** package (recommended)
3. Tap purchase button
4. Enter **sandbox tester credentials** when prompted
5. Confirm purchase

### Expected Behavior:
- [ ] StoreKit purchase sheet appears
- [ ] Asks for sandbox credentials
- [ ] Shows "You're all set" or similar confirmation
- [ ] Paywall dismisses automatically
- [ ] All swaps are now unlocked (no lock icons)
- [ ] `isPremium = true`

### Console Output:
```
✅ Purchase successful - Premium: true
🔄 Customer info updated - Premium: true
```

---

## Test 4: Premium Access Verification

### After Successful Purchase:

1. Go to **Swaps** tab
2. Check that all swaps are **unlocked** (no blur, no lock icon)
3. Tap "Set as Go-To" on any swap
4. Should work without showing paywall

### What to Check:
- [ ] No lock icons visible
- [ ] No blur on swap titles
- [ ] "Unlock All Swaps" button is gone
- [ ] Can interact with all swaps freely

---

## Test 5: Restore Purchases

### Steps:
1. **Delete the app** from your device
2. **Reinstall** from Xcode (Run)
3. Go to Swaps tab → Trigger paywall
4. Tap **"Restore Purchases"**

### Expected Behavior:
- [ ] Shows loading indicator (brief)
- [ ] Shows success alert: "Purchases Restored"
- [ ] Paywall dismisses after 1.5 seconds
- [ ] All swaps unlocked

### Console Output:
```
✅ Purchases restored - Premium: true
🔄 Customer info updated - Premium: true
```

### If No Purchases Found:
- [ ] Shows error alert: "No active subscriptions found"
- [ ] Paywall stays open
- [ ] User can try purchasing again

---

## Test 6: App Relaunch Persistence

### Steps:
1. With premium active, **force quit** the app
2. **Reopen** the app
3. Go to Swaps tab

### Expected Behavior:
- [ ] Premium status persists (swaps still unlocked)
- [ ] No need to restore
- [ ] Console shows premium on refresh

### Console Output:
```
✅ RevenueCat configured with API key
✅ Customer info refreshed - Premium: true
```

---

## Test 7: Offline Mode

### Steps:
1. With premium active, **enable Airplane Mode**
2. **Force quit** and **reopen** app
3. Go to Swaps tab

### Expected Behavior:
- [ ] Premium status still works (cached locally)
- [ ] All swaps unlocked
- [ ] No errors in console

---

## Test 8: Customer Center (Premium Users Only)

### Steps:
1. With premium active, add this button to InsightsView or Settings:

```swift
if revenueCat.canShowCustomerCenter {
    Button("Manage Subscription") {
        showCustomerCenter = true
    }
    .sheet(isPresented: $showCustomerCenter) {
        CustomerCenterView()
    }
}
```

2. Tap "Manage Subscription"

### Expected Behavior:
- [ ] Customer Center sheet appears
- [ ] Shows subscription details
- [ ] Shows "Manage" options
- [ ] "Done" button dismisses

---

## Test 9: Subscription Expiry (Optional)

### Using Sandbox Accelerated Time:
- Sandbox subscriptions expire quickly (5 min for 1 month)
- Wait for expiry, then check:
  - [ ] `isPremium = false`
  - [ ] Swaps are locked again
  - [ ] Paywall appears on tap

---

## 🐛 Common Issues & Solutions

### Issue: "No offerings found"
**Console:** `⚠️ No current offering found`

**Solution:**
1. Check RevenueCat Dashboard
2. Ensure you have a "Current Offering" set
3. Verify products are attached to offering

---

### Issue: "Purchase failed - Cannot connect to iTunes Store"
**Solution:**
1. Run on **real device** (not simulator)
2. Sign out of App Store in Settings
3. Use valid sandbox tester credentials
4. Check internet connection

---

### Issue: "Invalid Product ID"
**Solution:**
1. Verify product IDs match exactly:
   - App Store Connect: `monthly`, `yearly`
   - RevenueCat Dashboard: same IDs
2. Wait 2-4 hours after creating products in App Store Connect
3. Try clearing derived data in Xcode

---

### Issue: Premium not unlocking after purchase
**Console:** Check for `✅ Purchase successful - Premium: true`

**Solution:**
1. Check entitlement ID: `"Blue Jay Swaps Pro"`
2. Verify entitlement is attached to products in RevenueCat
3. Check `AppModel.isPremium` computed property is correct

---

### Issue: App crashes on launch
**Solution:**
1. Verify RevenueCat SDK is properly installed
2. Check import statements: `import RevenueCat`, `import RevenueCatUI`
3. Ensure new files are added to Xcode target
4. Clean build folder: Cmd+Shift+K

---

## 📊 Debug Commands

### Check Premium Status:
```swift
// Add to any button in your app for debugging
Button("Debug Premium") {
    print("🔍 isPremium: \(appModel.isPremium)")
    print("🔍 RC isPremium: \(RevenueCatService.shared.isPremium)")
    print("🔍 Has offerings: \(RevenueCatService.shared.offerings != nil)")
    print("🔍 Packages: \(RevenueCatService.shared.availablePackages.count)")
}
```

### Force Refresh Customer Info:
```swift
Button("Sync Premium") {
    Task {
        await RevenueCatService.shared.refreshCustomerInfo()
    }
}
```

---

## ✅ Success Criteria

Your integration is working correctly if:

1. ✅ App launches without crashes
2. ✅ Offerings load successfully
3. ✅ Paywall displays with real product info
4. ✅ Sandbox purchase completes
5. ✅ Premium status updates immediately after purchase
6. ✅ All swaps unlock after purchase
7. ✅ Restore purchases works after reinstall
8. ✅ Premium status persists across app launches
9. ✅ Works offline (cached entitlements)
10. ✅ Console logs show correct premium state

---

## 📞 Need Help?

- **RevenueCat Docs:** https://www.revenuecat.com/docs
- **Community Forum:** https://community.revenuecat.com
- **Check Console:** Most issues show up in logs with ✅/❌ indicators

---

## 🎉 Ready for Production?

Before submitting to App Store:

- [ ] Switch to **production API key**
- [ ] Set `Purchases.logLevel = .info`
- [ ] Test on multiple devices
- [ ] Test with real Apple ID (not sandbox)
- [ ] Verify subscription terms and pricing
- [ ] Add privacy policy and terms links
- [ ] Complete App Store subscription review
