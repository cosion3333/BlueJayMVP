//
//  RecallView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct RecallView: View {
    @Environment(AppModel.self) private var appModel
    @State private var saved = false

    var body: some View {
        @Bindable var appModel = appModel
        
        Form {
            Section("24-hour Recall") {
                ForEach(0..<6, id: \.self) { index in
                    TextField("Item \(index + 1)", text: $appModel.recallItems[index])
                }

                Button("Save") {
                    appModel.saveRecall()
                    saved = true
                }
                .buttonStyle(.borderedProminent)
            }

            Section("Tips") {
                Text("List what you ate/drank from waking to bedtime. Be specific (brand/size).")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            Section("Search") {
                TextField("Search food database", text: $appModel.searchText)
            }
        }
        .navigationTitle("Diet Recall")
        .alert("Saved", isPresented: $saved) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview { NavigationStack { RecallView() } }
