//
//  RecallView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct RecallView: View {
    @AppStorage("recallText") private var recallText = ""
    @State private var saved = false

    var body: some View {
        Form {
            Section("24-hour Recall") {
                TextEditor(text: $recallText)
                    .frame(minHeight: 180)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary.opacity(0.3)))
                    .padding(.vertical, 4)

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
        }
        .navigationTitle("Diet Recall")
        .alert("Saved", isPresented: $saved) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview { NavigationStack { RecallView() } }
