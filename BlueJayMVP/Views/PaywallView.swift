//
//  PaywallView.swift
//  BlueJayMVP
//
//  Created by Cursor AI on 1/25/26.
//

import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Main content
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
                    
                    // Pricing (stub for now)
                    VStack(spacing: 16) {
                        // Annual plan (recommended)
                        PricingCard(
                            title: "Annual",
                            price: "$29.99/year",
                            savings: "Save 50%",
                            isRecommended: true
                        )
                        
                        // Monthly plan
                        PricingCard(
                            title: "Monthly",
                            price: "$4.99/month",
                            savings: nil,
                            isRecommended: false
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    // CTA Button
                    Button {
                        // For now, just toggle premium (Day 3: connect RevenueCat)
                        appModel.isPremium = true
                        dismiss()
                        print("🎉 Premium unlocked (stub - will connect RevenueCat)")
                    } label: {
                        Text("Start Free Trial")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.blue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    
                    // Fine print
                    VStack(spacing: 8) {
                        Text("7-day free trial, then $29.99/year")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Button {
                            // Restore purchases (stub)
                            print("Restore purchases (stub)")
                        } label: {
                            Text("Restore Purchases")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    // Legal links
                    HStack(spacing: 16) {
                        Button("Terms") {
                            // TODO: Open terms URL
                        }
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        
                        Text("•")
                            .foregroundStyle(.tertiary)
                        
                        Button("Privacy") {
                            // TODO: Open privacy URL
                        }
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    }
                    .padding(.bottom, 32)
                }
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
                .foregroundStyle(.blue)
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
    let title: String
    let price: String
    let savings: String?
    let isRecommended: Bool
    
    var body: some View {
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
                    Text(title)
                        .font(.headline)
                    
                    Text(price)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                if let savings = savings {
                    Text(savings)
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
}

// MARK: - Preview

#Preview {
    PaywallView()
        .environment(AppModel())
}
