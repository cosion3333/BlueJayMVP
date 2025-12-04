//
//  SwapsView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct SwapsView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        List {
            // Golden Path: Show focused food prominently
            if let focused = appModel.focusedFood {
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Focus")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(focused.rawValue)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        Image(systemName: "target")
                            .foregroundStyle(.green)
                            .font(.title2)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section("Select Target Food") {
                Picker("Target", selection: Binding(
                    get: { appModel.selectedTargetFood ?? .soda },
                    set: { appModel.loadSwaps(for: $0) }
                )) {
                    ForEach(TargetFood.allCases, id: \.self) { target in
                        Text(target.rawValue).tag(target)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                if appModel.activeCombos.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text("No swaps available")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        Spacer()
                    }
                } else {
                    ForEach(appModel.activeCombos) { combo in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(combo.title)
                                    .font(.headline)
                                Spacer()
                                Text("-\(combo.estKcalDrop) kcal")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(6)
                            }
                            Text(combo.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            } header: {
                Text("Recommended Swaps")
            } footer: {
                if !appModel.activeCombos.isEmpty {
                    let totalSavings = appModel.activeCombos.reduce(0) { $0 + $1.estKcalDrop }
                    Text("Potential savings: ~\(totalSavings) kcal per swap")
                }
            }
        }
        .navigationTitle("Blue Jay Swaps")
    }
}

#Preview { 
    NavigationStack { 
        SwapsView()
            .environment(AppModel())
    } 
}

