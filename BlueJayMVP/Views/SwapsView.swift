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
            
            Section("Swap Combos") {
                ForEach(appModel.activeCombos) { combo in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(combo.title).font(.headline)
                        Text(combo.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
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

