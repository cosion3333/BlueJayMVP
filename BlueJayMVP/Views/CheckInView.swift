//
//  CheckInView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//
import SwiftUI

struct CheckInView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        @Bindable var appModel = appModel
        
        Form {
            Section("Today") {
                Toggle("I replaced a bad food with a BJ combo", isOn: $appModel.replacedToday)
                Stepper("Replacements: \(appModel.replacementsCount)", value: $appModel.replacementsCount, in: 0...10)
                VStack(alignment: .leading) {
                    Text("Craving level: \(Int(appModel.cravingLevel))/10")
                    Slider(value: $appModel.cravingLevel, in: 1...10, step: 1)
                }
            }
            
            Section("Progress") {
                HStack {
                    Text("Current Streak")
                    Spacer()
                    Text("\(appModel.currentStreak) days")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Total Replacements")
                    Spacer()
                    Text("\(appModel.totalReplacements)")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("Notes") {
                Text("Celebrate the swap. Tomorrow pick the next highest-priority target.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            Button("Save Check-In") {
                appModel.saveCheckIn()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Daily Check-In")
    }
}

#Preview { NavigationStack { CheckInView() } }
