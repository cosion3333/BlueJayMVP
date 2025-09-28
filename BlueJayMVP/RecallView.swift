//
//  RecallView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct RecallView: View {
    @State private var recallItems = Array(repeating: "", count: 6)
    @State private var saved = false
    @State private var searchText = ""

    var body: some View {
        Form {
            Section("24-hour Recall") {
                ForEach(0..<6, id: \.self) { index in
                    TextField("Item \(index + 1)", text: $recallItems[index])
                }

                Button("Save") {
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
                TextField("Search food database", text: $searchText)
            }
        }
        .navigationTitle("Diet Recall")
        .alert("Saved", isPresented: $saved) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview { NavigationStack { RecallView() } }
