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
        let blueJayBlue = Color(red: 74/255, green: 144/255, blue: 226/255)
        let successGreen = Color(red: 76/255, green: 175/255, blue: 80/255)
        let premiumAmber = Color(red: 1.0, green: 193/255, blue: 7/255)
        
        HStack(spacing: 0) {
            TabBarButton(
                icon: "fork.knife",
                label: "Recall",
                isSelected: selectedTab == 0,
                activeColor: blueJayBlue
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 0
                }
            }
            
            TabBarButton(
                icon: "lightbulb.fill",
                label: "Insights",
                isSelected: selectedTab == 1,
                activeColor: successGreen
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedTab = 1
                }
            }
            
            TabBarButton(
                icon: "arrow.2.squarepath",
                label: "Swaps",
                isSelected: selectedTab == 2,
                activeColor: blueJayBlue,
                accentUnderlineColor: premiumAmber
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
    let activeColor: Color
    let accentUnderlineColor: Color?
    let action: () -> Void
    
    init(
        icon: String,
        label: String,
        isSelected: Bool,
        activeColor: Color,
        accentUnderlineColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.isSelected = isSelected
        self.activeColor = activeColor
        self.accentUnderlineColor = accentUnderlineColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? activeColor : .secondary)
                
                Text(label)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? activeColor : .secondary)
                
                if let accentUnderlineColor {
                    Capsule()
                        .fill(accentUnderlineColor)
                        .frame(width: 22, height: 3)
                        .opacity(isSelected ? 1.0 : 0.45)
                } else {
                    Color.clear
                        .frame(width: 22, height: 3)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background(
                isSelected
                    ? activeColor.opacity(0.12)
                    : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
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
