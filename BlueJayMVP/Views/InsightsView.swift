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
            Section("Tap to edit priority (1 = highest)") {
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
            }
        }
        .toolbar { EditButton() }
        .navigationTitle("Target Ranking")
    }
}

#Preview { NavigationStack { InsightsView() } }

