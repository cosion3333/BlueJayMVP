//
//  CombosView.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/5/25.
//

import SwiftUI

struct BJCombo: Identifiable {
    let id = UUID()
    var title: String
    var details: String
}

struct CombosView: View {
    @State private var combos: [BJCombo] = [
        .init(title: "Soda → Sparkling water + lime",
              details: "Keep cold cans ready. Add fresh lime; 0 kcal."),
        .init(title: "Chips → Greek yogurt + berries",
              details: "150–200g 0% yogurt + 100g berries."),
        .init(title: "Drive-thru breakfast → Oats + protein",
              details: "40g oats + scoop whey + cinnamon.")
    ]

    var body: some View {
        List(combos) { combo in
            VStack(alignment: .leading, spacing: 6) {
                Text(combo.title).font(.headline)
                Text(combo.details).font(.subheadline).foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Blue Jay Combos")
    }
}

#Preview { NavigationStack { CombosView() } }
