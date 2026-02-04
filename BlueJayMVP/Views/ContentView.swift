//
//  ContentView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/1/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var selectedTab = 0
    
    var body: some View {
        @Bindable var appModel = appModel
        
        VStack(spacing: 0) {
            // Main content area
            ZStack {
                switch selectedTab {
                case 0:
                    NavigationStack { RecallView(selectedTab: $selectedTab) }
                case 1:
                    NavigationStack { InsightsView(selectedTab: $selectedTab) }
                case 2:
                    NavigationStack { SwapsView(selectedTab: $selectedTab) }
                default:
                    NavigationStack { RecallView(selectedTab: $selectedTab) }
                }
            }
            
            // Custom full-width tab bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .sheet(isPresented: $appModel.showPaywall) {
            PaywallView()
        }
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "fork.knife",
                label: "Recall",
                isSelected: selectedTab == 0
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 0
                }
            }
            
            TabBarButton(
                icon: "lightbulb.fill",
                label: "Insights",
                isSelected: selectedTab == 1
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 1
                }
            }
            
            TabBarButton(
                icon: "arrow.2.squarepath",
                label: "Swaps",
                isSelected: selectedTab == 2
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 2
                }
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(.regularMaterial)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .blue : .secondary)
                
                Text(label)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? .blue : .secondary)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview { 
    ContentView()
        .environment(AppModel())
}
