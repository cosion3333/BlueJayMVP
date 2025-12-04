//
//  ContentView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack { RecallView() }
                .tabItem { Label("Recall", systemImage: "square.and.pencil") }

            NavigationStack { InsightsView() }
                .tabItem { Label("Insights", systemImage: "list.number") }

            NavigationStack { SwapsView() }
                .tabItem { Label("Swaps", systemImage: "sparkles") }
        }
    }
}

#Preview { ContentView() }
