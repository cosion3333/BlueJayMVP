//
//  CheckInView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//
import SwiftUI

struct CheckInView: View {
    @State private var replacedToday = false
    @State private var replacementsCount = 0
    @State private var cravingLevel = 5.0  // 1–10

    var body: some View {
        Form {
            Section("Today") {
                Toggle("I replaced a bad food with a BJ combo", isOn: $replacedToday)
                Stepper("Replacements: \(replacementsCount)", value: $replacementsCount, in: 0...10)
                VStack(alignment: .leading) {
                    Text("Craving level: \(Int(cravingLevel))/10")
                    Slider(value: $cravingLevel, in: 1...10, step: 1)
                }
            }
            Section("Notes") {
                Text("Celebrate the swap. Tomorrow pick the next highest-priority target.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            Button("Save Check-In") {
                // TODO: persist locally or to Firebase later
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Daily Check-In")
    }
}

#Preview { NavigationStack { CheckInView() } }
