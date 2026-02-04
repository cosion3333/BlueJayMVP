//
//  SwapsView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

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
                HStack {
                    Image(systemName: "chart.bar.fill")
                    Text("Go to Insights")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Focus Card
    
    private var focusCardView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Focus")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    if let focused = appModel.focusedFood {
                        Text(focused.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
                
                Button {
                    selectedTab = 1
                } label: {
                    Text("Change")
                        .font(.subheadline)
                        .foregroundStyle(Color.accentColor)
                }
                
                Image(systemName: "target")
                    .foregroundStyle(.green)
                    .font(.title2)
            }
            .padding()
            .background(.background)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
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
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 70, height: 50)
                    .overlay(
                        Text(combo.emoji)
                            .font(.system(size: 28))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(combo.title)
                        .font(.headline)
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
            .padding()
            .background(.background)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
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
                Text("Your Go-To for \(appModel.focusedFood?.name ?? "")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
            
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 80, height: 60)
                    .overlay(
                        Text(goToSwap.emoji)
                            .font(.system(size: 32))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goToSwap.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(goToSwap.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentColor.opacity(0.3), lineWidth: 2)
        )
    }
    
    // MARK: - Other Swaps Section
    
    private var otherSwapsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Other Swaps")
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
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
            
            // Upgrade button for free users
            if !appModel.isPremium {
                upgradeButton
            }
        }
    }
    
    private func otherSwapCard(_ combo: SwapCombo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 70, height: 50)
                    .overlay(
                        Text(combo.emoji)
                            .font(.system(size: 28))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(combo.title)
                        .font(.headline)
                    
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
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(.background)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
    
    // MARK: - Locked Swap Card (Free Tier)
    
    private func lockedSwapCard(_ combo: SwapCombo) -> some View {
        Button {
            appModel.presentPaywall()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 70, height: 50)
                        .overlay(
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.secondary)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(combo.title)
                            .font(.headline)
                            .blur(radius: 4)
                        
                        Text(combo.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .blur(radius: 4)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.blue)
                        .font(.title3)
                }
            }
            .padding()
            .background(.background)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Upgrade Button
    
    private var upgradeButton: some View {
        Button {
            appModel.presentPaywall()
        } label: {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text("Unlock All Swaps")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                Text("Get all personalized recommendations")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
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
        .padding(.top, 8)
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
            
            // Weekly count - subtle text above button (Option B)
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
            
            // Primary action button
            Button {
                if appModel.goToSwap == nil, 
                   let selectedId = selectedSwapId,
                   let selectedCombo = appModel.activeCombos.first(where: { $0.id == selectedId }) {
                    // State 2: Set as Go-To
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        appModel.setGoToSwap(selectedCombo)
                    }
                } else if appModel.goToSwap != nil {
                    // State 3: Log usage
                    appModel.logSwapUse()
                    withAnimation {
                        showUsageConfirmation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showUsageConfirmation = false
                        }
                    }
                }
            } label: {
                Text(appModel.goToSwap == nil ? "Set as My Go-To Swap" : "I Used My Go-To Swap")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        (appModel.goToSwap != nil || selectedSwapId != nil) 
                            ? Color.accentColor
                            : Color.gray
                    )
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .cornerRadius(12)
            }
            .disabled(appModel.goToSwap == nil && selectedSwapId == nil)
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

