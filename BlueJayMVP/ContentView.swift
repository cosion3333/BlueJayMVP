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
                .tabItem { Label("Recall", systemImage: "clock.arrow.circlepath") }

            NavigationStack { RankingView() }
                .tabItem { Label("Ranking", systemImage: "list.number") }

            NavigationStack { CombosView() }
                .tabItem { Label("BJ Combos", systemImage: "leaf") }

            NavigationStack { CheckInView() }
                .tabItem { Label("Check-In", systemImage: "checkmark.seal") }
        }
    }
}

#Preview { ContentView() }
