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
    @FocusState private var isInputFocused: Bool
    @Binding var selectedTab: Int
    
    var body: some View {
        @Bindable var appModel = appModel
        
        ZStack(alignment: .bottom) {
            // Main scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Instructions at top
                    Text("List everything you ate today.")
                        .font(.system(size: 22))
                        .foregroundStyle(.secondary)
                    
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
                        // Auto-navigate to Insights (Tab 2)
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = 1
                        }
                    }
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.regularMaterial)
            }
        }
        .navigationTitle("Diet Recall")
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
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 0.5)
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
