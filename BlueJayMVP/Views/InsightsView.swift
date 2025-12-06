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
            
            // Main section: Top 3 detected foods with numbered badges
            if !appModel.detectedFoods.isEmpty {
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
                                        .fill(appModel.focusedFood == food ? Color.green : Color.gray.opacity(0.2))
                                        .frame(width: 36, height: 36)
                                    
                                    Text("\(index + 1)")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(appModel.focusedFood == food ? .white : .secondary)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(food.rawValue)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text(appModel.focusedFood == food ? "Current focus" : "Tap to focus & see swaps")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                // Visual indicator for selected
                                if appModel.focusedFood == food {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .font(.title3)
                                }
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

