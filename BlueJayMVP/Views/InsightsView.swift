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

    var body: some View {
        @Bindable var appModel = appModel
        
        List {
            // Step indicator
            Section {
                Text("Step 2 · Focus")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            // Current Focus Section - Prominent display of active focus
            if let focusedFood = appModel.focusedFood, !appModel.detectedFoods.isEmpty {
                Section {
                    HStack(spacing: 16) {
                        // Rank badge with number
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 40, height: 40)
                            
                            if let index = appModel.detectedFoods.firstIndex(of: focusedFood) {
                                Text("\(index + 1)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(focusedFood.rawValue)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            
                            Text("Your weekly focus")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title2)
                    }
                    .padding(.vertical, 8)
                } header: {
                    HStack(spacing: 6) {
                        Image(systemName: "target")
                            .font(.caption)
                        Text("Your Current Focus")
                    }
                }
            }
            
            // Other Opportunities Section - Alternative foods to focus on
            if !appModel.detectedFoods.isEmpty && appModel.focusedFood != nil {
                let otherFoods = appModel.detectedFoods.filter { $0 != appModel.focusedFood }
                
                if !otherFoods.isEmpty {
                    Section {
                        ForEach(Array(otherFoods.enumerated()), id: \.element) { _, food in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    appModel.setFocus(on: food)
                                }
                            } label: {
                                HStack(spacing: 16) {
                                    // Rank badge with number
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 36, height: 36)
                                        
                                        if let index = appModel.detectedFoods.firstIndex(of: food) {
                                            Text("\(index + 1)")
                                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(food.rawValue)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        
                                        Text("Tap to switch focus")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right.circle")
                                        .foregroundStyle(.secondary)
                                        .font(.title3)
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    } header: {
                        Text("Other Opportunities")
                    } footer: {
                        Text("You can switch your focus at any time")
                    }
                }
            }
            
            // If no focus selected yet, show all as opportunities
            if !appModel.detectedFoods.isEmpty && appModel.focusedFood == nil {
                Section {
                    ForEach(Array(appModel.detectedFoods.enumerated()), id: \.element) { index, food in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                appModel.setFocus(on: food)
                            }
                        } label: {
                            HStack(spacing: 16) {
                                // Rank badge with number
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    
                                    Text("\(index + 1)")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(.secondary)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(food.rawValue)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text("Tap to focus & see swaps")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right.circle")
                                    .foregroundStyle(.secondary)
                                    .font(.title3)
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Opportunities from Your Recall")
                } footer: {
                    Text("Choose one food to focus on this week")
                }
            }
            
            // CTA Card - Next step
            if appModel.focusedFood != nil {
                Section {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = 2
                        }
                    } label: {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Next Step: View Swaps")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                
                                Text("See your swap recommendations")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundStyle(.green)
                                .font(.title2)
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Empty state (if no foods detected yet)
            if appModel.detectedFoods.isEmpty {
                Section {
                    VStack(spacing: 16) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary)
                        
                        VStack(spacing: 8) {
                            Text("No Foods Analyzed Yet")
                                .font(.headline)
                            
                            Text("Go to Recall to log your diet and find swap opportunities")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button {
                            selectedTab = 0
                        } label: {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                Text("Go to Recall")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                }
            }
        }
        .navigationTitle("Insights & Focus")
    }
}

#Preview { 
    @Previewable @State var tab = 1
    NavigationStack { 
        InsightsView(selectedTab: $tab)
            .environment(AppModel())
    } 
}

