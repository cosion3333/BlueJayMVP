//
//  Models.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 11/25/25.
//

import Foundation

// MARK: - Target Foods

/// Foods we can suggest swaps for
enum TargetFood: String, CaseIterable {
    case fries = "Fries"
    case soda = "Soda"
    case chips = "Chips"
}

// MARK: - Swap Combos

/// A recommended food swap with nutritional info
struct SwapCombo: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let estKcalDrop: Int
}

// MARK: - Ranked Foods

/// A target food with user-assigned priority
struct RankedFood: Identifiable, Codable {
    let id: UUID
    var name: String
    var priority: Int   // 1 = replace first
    
    init(id: UUID = UUID(), name: String, priority: Int) {
        self.id = id
        self.name = name
        self.priority = priority
    }
}

