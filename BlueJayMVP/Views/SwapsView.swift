//
//  SwapsView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

// MARK: - Brand Colors

private let swapGreen = Color(red: 0.20, green: 0.65, blue: 0.45) // #33A673

struct SwapsView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedTab: Int
    @State private var selectedSwapId: UUID?
    @State private var showUsageConfirmation = false
    
    var body: some View {
        @Bindable var appModel = appModel
        
        ZStack(alignment: .bottom) {
            // Main content
            ScrollView {
                VStack(spacing: 20) {
                    // Show warning if insights are stale
                    if appModel.focusedFood != nil && !appModel.analysisComplete {
                        staleInsightsWarning
                    }
                    
                    // State 1: No focus set - Empty state
                    if appModel.focusedFood == nil {
                        emptyStateView
                            .padding(.top, 40)
                    } 
                    // State 2 & 3: Focus is set
                    else {
                        focusCardView
                        
                        // State 3: Go-To swap is set (Steady State)
                        if let goToSwap = appModel.goToSwap {
                            goToSwapHeroCard(goToSwap)
                            otherSwapsSection
                        } 
                        // State 2: No Go-To yet (First Visit)
                        else {
                            firstVisitSection
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, appModel.focusedFood != nil ? 120 : 20)
            }
            
            // Bottom action bar (only when focus is set)
            if appModel.focusedFood != nil {
                bottomActionBar
            }
        }
        .navigationTitle("Blue Jay Swaps")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            // Pre-select first swap if no Go-To is set
            if appModel.goToSwap == nil && !appModel.activeCombos.isEmpty {
                selectedSwapId = appModel.activeCombos[0].id
            }
        }
    }
    
    // MARK: - Stale Insights Warning
    
    private var staleInsightsWarning: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Recall Changed")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Refresh your insights for updated swaps")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                selectedTab = 1 // Go to Insights tab
            } label: {
                Text("Review")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Empty State (No Focus)
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                Text("Pick a Focus First")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Choose one food on the Insights tab, then we'll show you swaps")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Button {
                selectedTab = 1
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "chart.bar.fill")
                        .font(.body)
                    Text("Go to Insights")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.accentColor.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Focus Card
    
    private var focusCardView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("YOUR FOCUS")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .kerning(0.8)
                    
                    if let focused = appModel.focusedFood {
                        Text(focused.name)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                
                Spacer()
                
                Button {
                    selectedTab = 1
                } label: {
                    Text("Change")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                }
                
                Image(systemName: "target")
                    .foregroundStyle(.green)
                    .font(.title2)
            }
            .padding(16)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
        }
    }
    
    // MARK: - State 2: First Visit (No Go-To Set)
    
    private var firstVisitSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let focused = appModel.focusedFood {
                Text("We've picked a suggested swap for \(focused.name). Tap a card to select, or choose another.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 12) {
                ForEach(appModel.activeCombos) { combo in
                    selectableSwapCard(combo)
                }
            }
        }
    }
    
    private func selectableSwapCard(_ combo: SwapCombo) -> some View {
        let isSelected = selectedSwapId == combo.id
        
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedSwapId = combo.id
            }
        } label: {
            HStack(spacing: 12) {
                // Food emoji icon
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 70, height: 50)
                    .overlay(
                        Text(combo.emoji)
                            .font(.system(size: 28))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(combo.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(combo.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                }
            }
            .padding(16)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 3)
            )
            .shadow(color: .black.opacity(isSelected ? 0.1 : 0.06), radius: isSelected ? 10 : 6, y: isSelected ? 4 : 2)
            .opacity(selectedSwapId == nil || isSelected ? 1.0 : 0.6)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - State 3: Go-To Swap Hero Card
    
    private func goToSwapHeroCard(_ goToSwap: SwapCombo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("YOUR GO-TO FOR \(appModel.focusedFood?.name.uppercased() ?? "")")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .kerning(0.8)
            }
            
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 80, height: 60)
                    .overlay(
                        Text(goToSwap.emoji)
                            .font(.system(size: 32))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goToSwap.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(goToSwap.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            // Inline logging for free users (sticky bar has upsell instead)
            if !appModel.isPremium {
                Button {
                    appModel.logSwapUse()
                    withAnimation {
                        showUsageConfirmation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showUsageConfirmation = false
                        }
                    }
                } label: {
                    Text("I Made This Swap!")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(swapGreen)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: swapGreen.opacity(0.3), radius: 6, y: 3)
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.04)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentColor.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: Color.accentColor.opacity(0.1), radius: 10, y: 4)
    }
    
    // MARK: - Other Swaps Section
    
    private var otherSwapsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("OTHER SWAPS")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .kerning(0.8)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                ForEach(appModel.activeCombos.filter { $0.id != appModel.goToSwap?.id }) { combo in
                    if appModel.isPremium {
                        // Premium: Show fully interactive cards
                        otherSwapCard(combo)
                    } else {
                        // Free: Show locked/blurred cards
                        lockedSwapCard(combo)
                    }
                }
            }
            
            // Upsell hint for free users (tap any locked card, or use sticky bar)
            if !appModel.isPremium {
                HStack(spacing: 6) {
                    Image(systemName: "lock.open.fill")
                        .font(.caption2)
                        .foregroundStyle(.blue.opacity(0.6))
                    Text("Tap any swap to unlock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
            }
        }
    }
    
    private func otherSwapCard(_ combo: SwapCombo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 70, height: 50)
                    .overlay(
                        Text(combo.emoji)
                            .font(.system(size: 28))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(combo.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(combo.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button {
                    appModel.logSwapUse()
                    withAnimation {
                        showUsageConfirmation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showUsageConfirmation = false
                        }
                    }
                } label: {
                    Text("Use Once")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.accentColor)
                }
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        appModel.setGoToSwap(combo)
                    }
                } label: {
                    Text("Set as Go-To")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
    
    // MARK: - Locked Swap Card (Free Tier)
    
    private func lockedSwapCard(_ combo: SwapCombo) -> some View {
        Button {
            appModel.presentPaywall()
        } label: {
            HStack(spacing: 12) {
                // Show emoji clearly — appetite trigger
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor.opacity(0.06))
                    .frame(width: 70, height: 50)
                    .overlay(
                        Text(combo.emoji)
                            .font(.system(size: 28))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(combo.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .blur(radius: 2.5)
                    
                    Text(combo.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .blur(radius: 2.5)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Premium badge instead of plain lock
                Text("PRO")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(16)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        }
        .buttonStyle(.plain)
    }
    
    
    // MARK: - Bottom Action Bar
    
    private var bottomActionBar: some View {
        VStack(spacing: 8) {
            // Inline confirmation message
            if showUsageConfirmation {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.subheadline)
                    Text("Nice swap! +1 this week")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Weekly count - subtle text above button
            if appModel.goToSwap != nil && appModel.swapUsesThisWeek > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                    Text("\(appModel.swapUsesThisWeek) swap\(appModel.swapUsesThisWeek == 1 ? "" : "s") this week")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            if appModel.goToSwap == nil {
                // State 2: first visit, picking a swap
                Button {
                    if let selectedId = selectedSwapId,
                       let selectedCombo = appModel.activeCombos.first(where: { $0.id == selectedId }) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            appModel.setGoToSwap(selectedCombo)
                        }
                    }
                } label: {
                    Text("Set as My Go-To Swap")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedSwapId != nil ? Color.accentColor : Color.gray.opacity(0.4))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: selectedSwapId != nil ? Color.accentColor.opacity(0.3) : .clear, radius: 8, y: 4)
                }
                .disabled(selectedSwapId == nil)
            } else if appModel.isPremium {
                // Premium: logging CTA in sticky bar
                Button {
                    appModel.logSwapUse()
                    withAnimation {
                        showUsageConfirmation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showUsageConfirmation = false
                        }
                    }
                } label: {
                    Text("I Made This Swap!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(swapGreen)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: swapGreen.opacity(0.3), radius: 8, y: 4)
                }
            } else {
                // Free user: upsell owns the sticky bar
                Button {
                    appModel.presentPaywall()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("Unlock All Blue Jay Swaps")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 8, y: 4)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
    }
}

#Preview { 
    @Previewable @State var tab = 2
    NavigationStack { 
        SwapsView(selectedTab: $tab)
            .environment(AppModel())
    } 
}

