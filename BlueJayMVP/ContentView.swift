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

            NavigationStack { RankingView() }
                .tabItem { Label("Ranking", systemImage: "list.number") }

            NavigationStack { CombosView() }
                .tabItem { Label("Combos", systemImage: "sparkles") }
        }
    }
}

#Preview { ContentView() }
