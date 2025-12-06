//
//  RecallView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct RecallView: View {
    @Environment(AppModel.self) private var appModel
    @State private var newItemText = ""
    @State private var showAnalysisAlert = false
    @FocusState private var isInputFocused: Bool
    @Binding var selectedTab: Int
    
    var body: some View {
        @Bindable var appModel = appModel
        
        ZStack(alignment: .bottom) {
            // Main scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 24-Hour Recall Section
                    VStack(alignment: .leading, spacing: 8) {
                        SectionLabel("24-HOUR RECALL")
                        RecallCard(
                            items: appModel.recallItems,
                            newItemText: $newItemText,
                            isInputFocused: $isInputFocused,
                            onAdd: {
                                appModel.addRecallItem(newItemText)
                                newItemText = ""
                            },
                            onRemove: { index in
                                appModel.removeRecallItem(at: index)
                            }
                        )
                    }
                    
                    // Tips Section
                    VStack(alignment: .leading, spacing: 8) {
                        SectionLabel("TIPS")
                        TipsCard()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100) // Space for sticky footer
            }
            
            // Sticky footer with analyze button
            VStack(spacing: 0) {
                Divider()
                AnalyzeButton(
                    isEnabled: appModel.activeRecallItems.count >= 2,
                    action: {
                        isInputFocused = false
                        appModel.saveRecall()
                        appModel.analyzeRecall()
                        showAnalysisAlert = true
                    }
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.regularMaterial)
            }
        }
        .navigationTitle("Diet Recall")
        .alert("Analysis Complete!", isPresented: $showAnalysisAlert) {
            Button("View Insights") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 1
                }
            }
            Button("OK", role: .cancel) {}
        } message: {
            if appModel.detectedFoods.isEmpty {
                Text("No swappable foods detected. Try adding items like soda, fries, or chips.")
            } else {
                Text("Found \(appModel.detectedFoods.count) food(s) you can swap! Go to the Insights tab to set your focus.")
            }
        }
    }
}

// MARK: - Section Label

struct SectionLabel: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .kerning(0.5)
    }
}

// MARK: - Recall Card

struct RecallCard: View {
    let items: [String]
    @Binding var newItemText: String
    var isInputFocused: FocusState<Bool>.Binding
    let onAdd: () -> Void
    let onRemove: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // List of items or empty state
            if items.isEmpty {
                // Empty state
                VStack(spacing: 8) {
                    Text("What did you eat today?")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    Text("Start logging below.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                // Dynamic list of items
                VStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        RecallItemRow(
                            text: item,
                            onRemove: { onRemove(index) }
                        )
                        
                        if index < items.count - 1 {
                            Divider()
                                .padding(.leading, 32)
                        }
                    }
                }
            }
            
            // Divider before add field
            if !items.isEmpty {
                Divider()
            }
            
            // Add new item field
            HStack(spacing: 12) {
                TextField("Add what you ate or drank…", text: $newItemText)
                    .focused(isInputFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        onAdd()
                    }
                
                Button(action: onAdd) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(newItemText.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray.opacity(0.3) : Color.accentColor)
                }
                .disabled(newItemText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color(.separator), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

// MARK: - Recall Item Row

struct RecallItemRow: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Bullet point
            Circle()
                .fill(.secondary)
                .frame(width: 4, height: 4)
            
            // Item text
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
            // Remove button
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.body)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// MARK: - Tips Card

struct TipsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("List what you ate/drank from waking to bedtime. A rough list is enough – don't worry about exact amounts.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color(.separator), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

// MARK: - Analyze Button

struct AnalyzeButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text("Analyze & Find Swaps")
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!isEnabled)
    }
}

// MARK: - Preview

#Preview { 
    @Previewable @State var tab = 0
    NavigationStack { 
        RecallView(selectedTab: $tab)
            .environment(AppModel())
    } 
}
