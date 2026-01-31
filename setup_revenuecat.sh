#!/bin/bash
# RevenueCat Integration Setup Verification Script

echo "🔍 Verifying RevenueCat Integration..."
echo ""

# Check if files exist
echo "📁 Checking files..."
files=(
    "BlueJayMVP/Services/RevenueCatService.swift"
    "BlueJayMVP/Views/CustomerCenterView.swift"
    "BlueJayMVP/App/BlueJayMVPApp.swift"
    "BlueJayMVP/App/AppModel.swift"
    "BlueJayMVP/Views/PaywallView.swift"
)

all_files_exist=true
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file - MISSING!"
        all_files_exist=false
    fi
done

echo ""
echo "📦 Required Swift Packages:"
echo "  1. RevenueCat (https://github.com/RevenueCat/purchases-ios-spm.git)"
echo "  2. RevenueCatUI (included in purchases-ios-spm)"
echo ""

echo "🔧 Configuration Checklist:"
echo ""
echo "  [ ] Install RevenueCat SDK via Swift Package Manager"
echo "  [ ] Add RevenueCatService.swift to Xcode project"
echo "  [ ] Add CustomerCenterView.swift to Xcode project"
echo "  [ ] Configure RevenueCat Dashboard (https://app.revenuecat.com)"
echo "      - Create entitlement: 'Blue Jay Swaps Pro'"
echo "      - Add products: 'monthly' and 'yearly'"
echo "      - Create current offering with both packages"
echo "  [ ] Set up App Store Connect subscriptions"
echo "      - Create subscription group: 'Blue Jay Pro'"
echo "      - Add subscription: 'monthly'"
echo "      - Add subscription: 'yearly'"
echo "  [ ] Create sandbox tester in App Store Connect"
echo "  [ ] Build and run on device"
echo "  [ ] Test purchase flow"
echo "  [ ] Test restore purchases"
echo ""

echo "📖 Documentation:"
echo "  - Full guide: REVENUECAT_INTEGRATION.md"
echo "  - RevenueCat docs: https://www.revenuecat.com/docs/getting-started/installation/ios"
echo ""

if [ "$all_files_exist" = true ]; then
    echo "✅ All code files are in place!"
    echo "   Next step: Open Xcode and install the RevenueCat SDK package."
else
    echo "⚠️  Some files are missing. Please check the output above."
fi

echo ""
echo "🚀 To continue:"
echo "   1. Open BlueJayMVP.xcodeproj in Xcode"
echo "   2. Go to File → Add Package Dependencies..."
echo "   3. Enter: https://github.com/RevenueCat/purchases-ios-spm.git"
echo "   4. Add both RevenueCat and RevenueCatUI libraries"
echo "   5. Add the new Swift files to your Xcode project"
echo "   6. Build and run!"
echo ""
