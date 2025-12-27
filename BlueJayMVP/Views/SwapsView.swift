//
//  SwapsView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct SwapsView: View {
    @Environment(AppModel.self) private var appModel
    @Binding var selectedTab: Int
    @State private var selectedSwapId: UUID?
    @State private var showUsageConfirmation = false
    
    var body: some View {
        @Bindable var appModel = appModel
        
        ZStack(alignment: .bottom) {
            // Main content
            ScrollView {
                VStack(spacing: 20) {
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
                // Placeholder icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .foregroundStyle(Color.accentColor)
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
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .font(.title2)
                            .foregroundStyle(Color.accentColor)
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
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(10)
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
                    otherSwapCard(combo)
                }
            }
        }
    }
    
    private func otherSwapCard(_ combo: SwapCombo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .foregroundStyle(.secondary)
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
            
            HStack(spacing: 8) {
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
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.accentColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        appModel.setGoToSwap(combo)
                    }
                } label: {
                    Text("Set as Go-To")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
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
    
    // MARK: - Bottom Action Bar
    
    private var bottomActionBar: some View {
        VStack(spacing: 12) {
            // Inline confirmation message
            if showUsageConfirmation {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Nice swap! +1 this week")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Active swaps count
            
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
                HStack {
                    if appModel.goToSwap == nil {
                        Text("Set as My Go-To Swap")
                    } else {
                        Text("I Used My Go-To Swap")
                    }
                }
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
            
            // Weekly usage tracker (when Go-To is set)
            if appModel.goToSwap != nil && appModel.swapUsesThisWeek > 0 {
                Text("You've used your Go-To \(appModel.swapUsesThisWeek)× this week")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            Color(.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
        )
    }
}

#Preview { 
    @Previewable @State var tab = 2
    NavigationStack { 
        SwapsView(selectedTab: $tab)
            .environment(AppModel())
    } 
}

