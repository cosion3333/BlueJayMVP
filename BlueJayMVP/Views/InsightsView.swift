//
//  InsightsView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct InsightsView: View {
    @Environment(AppModel.self) private var appModel
    @Binding var selectedTab: Int
    @State private var showOtherOpportunities = true
    
    var body: some View {
        @Bindable var appModel = appModel
        
        ZStack(alignment: .bottom) {
            // Main scrollable content
            ScrollView {
                VStack(spacing: 24) {
                    // Show data load error if data failed to load
                    if let errorMsg = BadFoodsService.dataLoadError {
                        dataLoadErrorView(errorMsg)
                    } else {
                        // Show warning if recall changed after analysis
                        if appModel.focusedFood != nil && !appModel.analysisComplete {
                            recallChangedWarning
                        }
                        
                        if appModel.detectedFoods.isEmpty {
                            // Empty state
                            emptyStateView
                        } else {
                        // Top priority card (first = worst)
                        if let topFood = appModel.detectedFoods.first {
                            topPriorityCardContent(topFood)
                        }
                        
                            // Other opportunities (if more than 1 detected)
                            if appModel.detectedFoods.count > 1 {
                                otherOpportunitiesSection
                            }
                            
                            // Weekly progress card (at bottom)
                            weeklyProgressCard
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100) // Space for sticky button
            }
            
            // Sticky "Find Swaps" button
            if !appModel.detectedFoods.isEmpty {
                VStack(spacing: 0) {
                    Divider()
                    Button {
                        if let topFood = appModel.detectedFoods.first {
                            appModel.setFocus(on: topFood)
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = 2  // Navigate to Swaps tab
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("Find Swaps")
                                .font(.headline)
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 8, y: 4)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.regularMaterial)
                }
            }
        }
        .navigationTitle("Insights")
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Data Load Error View
    
    private func dataLoadErrorView(_ errorMsg: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            
            VStack(spacing: 8) {
                Text("Data Load Error")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("The app's food database couldn't be loaded. Please reinstall the app.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(errorMsg)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 4)
            }
        }
        .padding(.top, 60)
    }
    
    // MARK: - Recall Changed Warning
    
    private var recallChangedWarning: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Recall Changed")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Your insights may be outdated")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                // Force re-analyze
                appModel.analyzeRecall()
            } label: {
                Text("Refresh")
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
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                Text("No Analysis Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Log your diet on the Recall tab first, then analyze to see opportunities")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Button {
                selectedTab = 0
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.pencil")
                        .font(.body)
                    Text("Go to Recall")
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
        .padding(.top, 60)
    }
    
    // MARK: - Top Priority Card Content (without button)
    
    private func topPriorityCardContent(_ food: BadFood) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("YOUR TOP PRIORITY")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .kerning(0.8)
                
                Spacer()
                
                // Priority badge
                Text("#\(food.priority)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor(for: food.priority))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            // Food info
            HStack(spacing: 12) {
                // Icon
                Circle()
                    .fill(priorityColor(for: food.priority).opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(priorityEmoji(for: food.priority))
                            .font(.title2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Priority #\(food.priority) of 40")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            // Auto-selected indicator
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.subheadline)
                
                Text("Set as This Week's Focus")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(priorityColor(for: food.priority).opacity(0.3), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
    }
    
    // MARK: - Other Opportunities Section
    
    private var otherOpportunitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Toggle header
            Button {
                withAnimation(.spring(response: 0.3)) {
                    showOtherOpportunities.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: showOtherOpportunities ? "chevron.down" : "chevron.right")
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    Text("Other Opportunities Detected (\(appModel.detectedFoods.count - 1))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .foregroundStyle(.secondary)
                .contentShape(Rectangle())
            }
            
            // Expanded list
            if showOtherOpportunities {
                VStack(spacing: 8) {
                    ForEach(appModel.detectedFoods.dropFirst(), id: \.id) { food in
                        otherFoodRow(food)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 6, y: 3)
    }
    
    private func otherFoodRow(_ food: BadFood) -> some View {
        HStack(spacing: 12) {
            // Priority indicator
            Circle()
                .fill(priorityColor(for: food.priority).opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(
                    Text("#\(food.priority)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(priorityColor(for: food.priority))
                )
            
            // Food name
            Text(food.name)
                .font(.subheadline)
            
            Spacer()
            
            // Change focus button
            Button {
                appModel.setFocus(on: food)
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 2
                }
            } label: {
                Text("Select")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    // MARK: - Weekly Progress Card
    
    private var weeklyProgressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                Text("THIS WEEK'S SWAPS")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .kerning(0.8)
                Spacer()
            }
            
            // Stats row
            HStack(spacing: 20) {
                // Swaps count
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(appModel.swapUsesThisWeek)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text("swaps logged")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Streak
                if appModel.currentStreak > 0 {
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("\(appModel.currentStreak)")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.orange)
                            Text("day\(appModel.currentStreak == 1 ? "" : "s")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Text("streak")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Progress bar (visual for 7-day goal)
            if appModel.swapUsesThisWeek > 0 {
                VStack(alignment: .leading, spacing: 6) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                            
                            // Progress
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [.orange, .yellow],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: min(geometry.size.width * CGFloat(appModel.swapUsesThisWeek) / 7.0, geometry.size.width), height: 8)
                        }
                    }
                    .frame(height: 8)
                    
                    Text(progressMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 6, y: 3)
    }
    
    private var progressMessage: String {
        let swaps = appModel.swapUsesThisWeek
        switch swaps {
        case 0:
            return "Log your first swap!"
        case 1...2:
            return "Good start! Keep going."
        case 3...4:
            return "You're building momentum!"
        case 5...6:
            return "Almost there! \(7 - swaps) more to hit 7."
        default:
            return "Amazing week! You're crushing it!"
        }
    }
    
    // MARK: - Helper Functions
    
    private func priorityColor(for priority: Int) -> Color {
        switch priority {
        case 1...10:
            return .red
        case 11...25:
            return .orange
        default:
            return .green
        }
    }
    
    private func priorityEmoji(for priority: Int) -> String {
        switch priority {
        case 1...10:
            return "🔴"
        case 11...25:
            return "🟡"
        default:
            return "🟢"
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var tab = 1
    
    NavigationStack {
        InsightsView(selectedTab: $tab)
            .environment(AppModel())
    }
}
