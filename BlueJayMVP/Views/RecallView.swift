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
    @State private var showAnalysisAlert = false
    @FocusState private var isInputFocused: Bool
    @Binding var selectedTab: Int

    var body: some View {
        @Bindable var appModel = appModel
        
        let itemCount = appModel.recallItems.filter { !$0.isEmpty }.count
        
        Form {
            Section("24-hour Recall") {
                ForEach(0..<6, id: \.self) { index in
                    TextField("Item \(index + 1)", text: $appModel.recallItems[index])
                        .focused($isInputFocused)
                }

                HStack(spacing: 12) {
                    Button("Save") {
                        isInputFocused = false
                        appModel.saveRecall()
                        saved = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Analyze & Find Swaps") {
                        isInputFocused = false
                        appModel.saveRecall()
                        appModel.analyzeRecall()
                        showAnalysisAlert = true
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(itemCount < 2)
                }
            }

            Section("Tips") {
                Text("List what you ate/drank from waking to bedtime. Be specific (brand/size).")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            Section("Search") {
                TextField("Search food database", text: $appModel.searchText)
                    .focused($isInputFocused)
            }
        }
        .navigationTitle("Diet Recall")
        .alert("Saved", isPresented: $saved) {
            Button("OK", role: .cancel) {}
        }
        .alert("Analysis Complete!", isPresented: $showAnalysisAlert) {
            Button("View Insights") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 1
                }
            }
        } message: {
            if appModel.detectedFoods.isEmpty {
                Text("No swappable foods detected. Try adding items like soda, fries, or chips.")
            } else {
                Text("Found \(appModel.detectedFoods.count) food(s) you can swap! Go to the Insights tab to set your focus.")
            }
        }
    }
}

#Preview { 
    @Previewable @State var tab = 0
    NavigationStack { 
        RecallView(selectedTab: $tab) 
    } 
}
