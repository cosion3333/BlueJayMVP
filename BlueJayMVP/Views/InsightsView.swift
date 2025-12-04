//
//  InsightsView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct InsightsView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        @Bindable var appModel = appModel
        
        List {
            // Golden Path: Show detected foods from analysis
            if !appModel.detectedFoods.isEmpty {
                Section {
                    ForEach(appModel.detectedFoods, id: \.self) { food in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(food.rawValue)
                                    .font(.headline)
                                Text("Tap to see swap options")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if appModel.focusedFood == food {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.title3)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            appModel.setFocus(on: food)
                        }
                    }
                } header: {
                    Text("Detected from Your Recall")
                } footer: {
                    Text("Select a food to focus on swapping")
                }
            }
            
            // Guide user to next step
            if appModel.focusedFood != nil {
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Next Step: View Swaps")
                                .font(.headline)
                            Text("Go to the Swaps tab to see recommendations")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.title2)
                    }
                }
            }
            
            // Optional: Existing food rankings section
            Section {
                ForEach($appModel.rankedFoods) { $item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Stepper("Priority \(item.priority)", value: $item.priority, in: 1...9)
                            .labelsHidden()
                            .onChange(of: item.priority) { _, _ in
                                appModel.updateRanking(appModel.rankedFoods)
                            }
                        Text("\(item.priority)")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                            .frame(width: 22)
                    }
                }
                .onMove { from, to in 
                    appModel.rankedFoods.move(fromOffsets: from, toOffset: to)
                    appModel.updateRanking(appModel.rankedFoods)
                }
            } header: {
                Text("Your Priority List (Optional)")
            } footer: {
                Text("Tap to edit priority (1 = highest)")
            }
        }
        .toolbar { EditButton() }
        .navigationTitle("Insights & Focus")
    }
}

#Preview { NavigationStack { InsightsView() } }

