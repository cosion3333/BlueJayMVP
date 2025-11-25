//
//  RankingView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct RankedFood: Identifiable {
    let id = UUID()
    var name: String
    var priority: Int   // 1 = replace first
}

struct RankingView: View {
    @State private var items: [RankedFood] = [
        .init(name: "Sugary soda", priority: 1),
        .init(name: "Chips at night", priority: 2),
        .init(name: "Drive-thru breakfast", priority: 3)
    ]

    var body: some View {
        List {
            Section("Tap to edit priority (1 = highest)") {
                ForEach($items) { $item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Stepper("Priority \(item.priority)", value: $item.priority, in: 1...9)
                            .labelsHidden()
                        Text("\(item.priority)")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                            .frame(width: 22)
                    }
                }
                .onMove { from, to in items.move(fromOffsets: from, toOffset: to) }
            }
        }
        .toolbar { EditButton() }
        .navigationTitle("Target Ranking")
    }
}

#Preview { NavigationStack { RankingView() } }
