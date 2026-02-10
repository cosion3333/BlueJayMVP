//
//  PaywallView.swift
//  BlueJayMVP
//
//  RevenueCat Paywall Integration
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppModel.self) private var appModel
    @Environment(RevenueCatService.self) private var revenueCat
    
    @State private var purchaseError: Error?
    @State private var showError = false
    @State private var showRestoreSuccess = false
    
    private let termsURL = URL(string: "https://bluejayapp.com/terms")!
    private let privacyURL = URL(string: "https://bluejayapp.com/privacy-policy")!
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Use RevenueCat's native paywall if offerings are loaded
            if let offering = revenueCat.offerings?.current {
                RevenueCatUI.PaywallView(
                    offering: offering,
                    displayCloseButton: false,
                    performPurchase: { package in
                        do {
                            _ = try await revenueCat.purchase(package: package)
                             #if DEBUG
                             print("✅ Purchase completed!")
                             #endif
                            dismiss()
                            return (false, nil)
                        } catch {
                            let nsError = error as NSError
                            let isCancelled = (error as? ErrorCode) == .purchaseCancelledError ||
                                nsError.code == ErrorCode.purchaseCancelledError.rawValue
                            if !isCancelled {
                                purchaseError = error
                                showError = true
                            }
                            return (isCancelled, isCancelled ? nil : error)
                        }
                    },
                    performRestore: {
                        do {
                            _ = try await revenueCat.restorePurchases()
                            #if DEBUG
                            print("✅ Restore completed!")
                            #endif
                            if revenueCat.isPremium {
                                showRestoreSuccess = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    dismiss()
                                }
                                return (true, nil)
                            } else {
                                let error = NSError(
                                    domain: "BlueJay",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No active subscriptions found"]
                                )
                                purchaseError = error
                                showError = true
                                return (false, error)
                            }
                        } catch {
                            purchaseError = error
                            showError = true
                            return (false, error)
                        }
                    }
                )
                .paywallFooter()
            } else {
                // Custom paywall fallback
                customPaywallView
            }
            
            // Close button
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.tertiary)
                    .padding()
            }
        }
        .alert("Purchase Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            if let error = purchaseError {
                Text(error.localizedDescription)
            }
        }
        .alert("Purchases Restored", isPresented: $showRestoreSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your premium access has been restored!")
        }
        .task {
            // Ensure offerings are loaded
            if revenueCat.offerings == nil {
                await revenueCat.loadOfferings()
            }
        }
    }
    
    // MARK: - Custom Paywall (Fallback)
    
    private var customPaywallView: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Unlock All Blue Jay Swaps")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Get unlimited access to 90+ healthy alternatives")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 40)
                
                // Features
                VStack(spacing: 20) {
                    FeatureRow(
                        icon: "fork.knife",
                        title: "90+ Swap Combos",
                        description: "Trade bad foods for delicious, healthy alternatives"
                    )
                    
                    FeatureRow(
                        icon: "target",
                        title: "Personalized Focus",
                        description: "AI-powered analysis of your worst foods"
                    )
                    
                    FeatureRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Track Progress",
                        description: "See your wins and build healthy streaks"
                    )
                    
                    FeatureRow(
                        icon: "sparkles",
                        title: "Weekly Updates",
                        description: "Fresh recommendations based on your habits"
                    )
                }
                .padding(.horizontal, 24)
                
                // Pricing with actual RevenueCat packages
                if !revenueCat.availablePackages.isEmpty {
                    VStack(spacing: 16) {
                        ForEach(revenueCat.availablePackages, id: \.identifier) { package in
                            PricingCard(
                                package: package,
                                isRecommended: package.packageType == .annual
                            ) {
                                Task {
                                    do {
                                        _ = try await revenueCat.purchase(package: package)
                                        dismiss()
                                    } catch {
                                        purchaseError = error
                                        showError = true
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    // Loading state
                    ProgressView()
                        .padding(.horizontal, 24)
                }
                
                // Restore purchases button
                Button {
                    Task {
                        do {
                            _ = try await revenueCat.restorePurchases()
                            if revenueCat.isPremium {
                                showRestoreSuccess = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    dismiss()
                                }
                            } else {
                                purchaseError = NSError(
                                    domain: "BlueJay",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No active subscriptions found"]
                                )
                                showError = true
                            }
                        } catch {
                            purchaseError = error
                            showError = true
                        }
                    }
                } label: {
                    Text("Restore Purchases")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                
                // Auto-renewal disclosure
                VStack(spacing: 6) {
                    Text("Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Your Apple ID account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions in your App Store account settings.")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                // Legal links
                HStack(spacing: 16) {
                    Link("Terms", destination: termsURL)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    
                    Text("•")
                        .foregroundStyle(.tertiary)
                    
                    Link("Privacy", destination: privacyURL)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                .padding(.bottom, 28)
            }
        }
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Pricing Card

struct PricingCard: View {
    let package: Package
    let isRecommended: Bool
    let onPurchase: () -> Void
    
    var body: some View {
        Button(action: onPurchase) {
            VStack(spacing: 8) {
                if isRecommended {
                    HStack {
                        Spacer()
                        Text("RECOMMENDED")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .cornerRadius(4)
                        Spacer()
                    }
                    .padding(.top, -8)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(package.storeProduct.localizedTitle)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text(package.localizedPriceString)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                    
                    if isRecommended {
                        Text("Best Value")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                .padding()
            }
            .background(isRecommended ? Color.blue.opacity(0.05) : Color.gray.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isRecommended ? Color.blue : Color.gray.opacity(0.3), lineWidth: isRecommended ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    PaywallView()
        .environment(AppModel())
        .environment(RevenueCatService.shared)
}
