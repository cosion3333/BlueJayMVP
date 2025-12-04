# 🎯 Golden Path Testing Guide

## Overview
The Golden Path feature allows users to flow seamlessly through the app:
**Recall → Analyze → Insights → Set Focus → Find Swaps**

---

## ✅ Testing Steps

### **Step 1: Tab 1 - Recall View**
1. Open the app and navigate to the **Recall** tab
2. Enter foods that can be detected (test with these):
   - Item 1: `Coke`
   - Item 2: `French fries`
   - Item 3: `Doritos`
   - Item 4: `Pizza`
   - Item 5: `Apple`
   - Item 6: `Water`

3. Click **"Analyze & Find Swaps"** button
   - ✅ Should show alert: "Analysis Complete!"
   - ✅ Alert should say "Found 3 food(s) you can swap!"
   - ✅ Detected foods: Soda, Fries, Chips

---

### **Step 2: Tab 2 - Insights & Focus View**
1. Navigate to **Insights** tab
2. Should see section: **"Detected from Your Recall"**
3. Should show 3 foods:
   - ✅ Soda
   - ✅ Fries
   - ✅ Chips
4. **Tap on "Soda"**
   - ✅ Green checkmark should appear next to Soda
   - ✅ "Next Step: View Swaps" section should appear
   - ✅ Console log: "🎯 Focus set on: Soda"

---

### **Step 3: Tab 3 - Swaps View**
1. Navigate to **Swaps** tab
2. Should see:
   - ✅ **"Your Focus"** section showing "Soda" with target icon
   - ✅ Segmented picker with Soda selected
   - ✅ **"Recommended Swaps"** section with 2 swaps:
     - "Sparkling water + lime" (-150 kcal)
     - "Unsweetened iced tea + mint" (-140 kcal)
   - ✅ Footer: "Potential savings: ~290 kcal per swap"

---

## 🔄 Test Different Target Foods

### **Test Fries:**
1. Go to Insights → Tap "Fries"
2. Go to Swaps → Should show 3 swap options:
   - Chicken Pita + Tzatziki (-180 kcal)
   - Baked potato + salsa (-150 kcal)
   - Veggies + hummus (-200 kcal)

### **Test Chips:**
1. Go to Insights → Tap "Chips"
2. Go to Swaps → Should show 2 swap options:
   - Greek yogurt + berries (-100 kcal)
   - Air-popped popcorn (-80 kcal)

---

## 💾 Persistence Testing

### **Test State Persistence:**
1. Complete the Golden Path flow (select a focus)
2. **Force quit the app**
3. Reopen the app
4. ✅ Insights tab should still show detected foods
5. ✅ The focused food should still have a checkmark
6. ✅ Swaps tab should still show "Your Focus" section
7. ✅ Recall items should be preserved

---

## 🚨 Edge Cases to Test

### **No Swappable Foods:**
1. Go to Recall tab
2. Enter only non-swappable foods:
   - Item 1: `Salad`
   - Item 2: `Chicken breast`
   - Item 3: `Water`
3. Click "Analyze & Find Swaps"
4. ✅ Should show: "No swappable foods detected. Try adding items like soda, fries, or chips."

### **Minimum Items Required:**
1. Go to Recall tab
2. Enter only 1 item
3. ✅ "Analyze & Find Swaps" button should be **disabled**
4. Enter 2 or more items
5. ✅ Button should become **enabled**

### **Change Target Manually:**
1. Complete Golden Path (set focus on Soda)
2. Go to Swaps tab
3. Change segmented picker to "Fries"
4. ✅ Should show Fries swaps
5. ✅ "Your Focus" should still show "Soda"
6. Go back to Insights
7. ✅ Soda should still have checkmark

---

## 🎨 UI/UX Checks

### **Visual Elements:**
- ✅ Green checkmark icon appears for focused food
- ✅ Target icon appears in Swaps "Your Focus" section
- ✅ Calorie savings badges are green with light background
- ✅ "Next Step" guidance appears after setting focus
- ✅ Alert messages are clear and actionable

### **User Flow:**
- ✅ User understands where to go next at each step
- ✅ Buttons are properly labeled
- ✅ Alerts provide clear guidance
- ✅ No dead ends in the flow

---

## 🐛 Known Issues / Future Enhancements

### **Current Limitations:**
- No paywall integration yet (part of future work)
- Search field in Recall view is not functional yet
- Check-In view not integrated into this flow
- Real food database not yet connected (using mock data)

### **Next Steps:**
1. Add paywall after viewing swaps
2. Integrate real food detection API
3. Add analytics tracking for Golden Path completion
4. Add "Get Started" onboarding flow for first-time users

---

## 📊 Success Metrics

**A successful Golden Path flow includes:**
1. ✅ User enters at least 2 recall items
2. ✅ Analysis detects 1+ swappable foods
3. ✅ User selects a focus food
4. ✅ User views swap recommendations
5. ✅ State persists across app restarts

---

## 🚀 Build & Run

```bash
# Open in Xcode
open BlueJayMVP.xcodeproj

# Or build from command line
xcodebuild -scheme BlueJayMVP -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

**Last Updated:** December 4, 2025
**Version:** MVP v1.0 - Golden Path Implementation

