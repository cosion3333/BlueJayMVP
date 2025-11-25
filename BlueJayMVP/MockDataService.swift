//
//  MockDataService.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 11/25/25.
//

import Foundation

struct MockDataService {
    
    static let suggestedFoods: [String] = [
        "French fries", "Soda", "Potato chips", "Cookies",
        "Ice cream", "Burger", "Pizza", "Donut",
        "Greek yogurt", "Oats", "Apple", "Banana",
        "Chicken breast", "Salad", "Brown rice", "Beans"
    ]
    
    static func swaps(for target: TargetFood) -> [SwapCombo] {
        switch target {
        case .fries:
            return [
                SwapCombo(
                    id: UUID(),
                    title: "Chicken Pita + Tzatziki",
                    description: "~180 kcal less • +12g protein • ~5 min",
                    estKcalDrop: 180
                ),
                SwapCombo(
                    id: UUID(),
                    title: "Baked potato + salsa",
                    description: "Crispy, high volume • 10 min",
                    estKcalDrop: 150
                ),
                SwapCombo(
                    id: UUID(),
                    title: "Veggies + hummus",
                    description: "Crunchy, fiber-rich snack",
                    estKcalDrop: 200
                )
            ]
            
        case .soda:
            return [
                SwapCombo(
                    id: UUID(),
                    title: "Sparkling water + lime",
                    description: "0 kcal, fizzy & refreshing",
                    estKcalDrop: 150
                ),
                SwapCombo(
                    id: UUID(),
                    title: "Unsweetened iced tea + mint",
                    description: "Hydrating, no sugar",
                    estKcalDrop: 140
                )
            ]
            
        case .chips:
            return [
                SwapCombo(
                    id: UUID(),
                    title: "Greek yogurt + berries",
                    description: "Protein + fiber, sweet and filling",
                    estKcalDrop: 100
                ),
                SwapCombo(
                    id: UUID(),
                    title: "Air-popped popcorn",
                    description: "High volume, lower kcal than chips",
                    estKcalDrop: 80
                )
            ]
        }
    }
}

