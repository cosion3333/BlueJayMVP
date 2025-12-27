//
//  Models.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 11/25/25.
//

import Foundation

// MARK: - Bad Foods

/// Foods we can suggest swaps for - with priority ranking
struct BadFood: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let category: String
    let keywords: [String]
    let avgCalories: Int
    let priority: Int  // 1 = worst, 40 = least bad
}

// MARK: - Swap Combos

/// A recommended food swap with nutritional info
struct SwapCombo: Identifiable, Codable, Hashable {
    let id: UUID
    let targetFoodId: String  // Links to BadFood.id
    let title: String
    let description: String
    let estKcalDrop: Int
    let foods: [String]
    
    init(id: UUID = UUID(),
         targetFoodId: String,
         title: String,
         description: String,
         estKcalDrop: Int,
         foods: [String]) {
        self.id = id
        self.targetFoodId = targetFoodId
        self.title = title
        self.description = description
        self.estKcalDrop = estKcalDrop
        self.foods = foods
    }
}

// MARK: - Ranked Foods (Keep for backwards compatibility if needed)

/// A target food with user-assigned priority
struct RankedFood: Identifiable, Codable {
    let id: UUID
    var name: String
    var priority: Int
    
    init(id: UUID = UUID(), name: String, priority: Int) {
        self.id = id
        self.name = name
        self.priority = priority
    }
}

