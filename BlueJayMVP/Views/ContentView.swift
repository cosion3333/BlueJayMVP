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
        
        TabView(selection: $selectedTab) {
            NavigationStack { RecallView(selectedTab: $selectedTab) }
                .tabItem { Label("Recall", systemImage: "square.and.pencil") }
                .tag(0)

            NavigationStack { InsightsView(selectedTab: $selectedTab) }
                .tabItem { Label("Insights", systemImage: "list.number") }
                .tag(1)

            NavigationStack { SwapsView(selectedTab: $selectedTab) }
                .tabItem { Label("Swaps", systemImage: "sparkles") }
                .tag(2)
        }
        .sheet(isPresented: $appModel.showPaywall) {
            PaywallView()
        }
    }
}

#Preview { 
    ContentView()
        .environment(AppModel())
}
