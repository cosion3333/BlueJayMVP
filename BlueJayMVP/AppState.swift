//
//  AppState.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 11/25/25.
//

import Foundation
import SwiftUI

/// Central app state manager - single source of truth for app-wide data
@Observable
class AppState {
    
    // MARK: - Recall State
    var recallItems: [String] = Array(repeating: "", count: 6)
    var searchText: String = ""
    
    // MARK: - Ranking State
    var rankedFoods: [RankedFood] = [
        .init(name: "Sugary soda", priority: 1),
        .init(name: "Chips at night", priority: 2),
        .init(name: "Drive-thru breakfast", priority: 3)
    ]
    
    // MARK: - Combos State
    var activeCombos: [SwapCombo] = []
    var selectedTargetFood: TargetFood?
    
    // MARK: - Check-In State
    var replacedToday: Bool = false
    var replacementsCount: Int = 0
    var cravingLevel: Double = 5.0  // 1-10 scale
    var lastCheckInDate: Date?
    
    // MARK: - User Progress
    var currentStreak: Int = 0
    var totalReplacements: Int = 0
    var completedCheckIns: Int = 0
    
    // MARK: - Initialization
    init() {
        loadDefaultCombos()
    }
    
    // MARK: - Actions
    
    /// Save recall items (placeholder for persistence)
    func saveRecall() {
        print("📝 Saving recall items: \(recallItems.filter { !$0.isEmpty })")
        // TODO: Persist to UserDefaults or Firebase
    }
    
    /// Load suggested swaps for a target food
    func loadSwaps(for target: TargetFood) {
        selectedTargetFood = target
        activeCombos = MockDataService.swaps(for: target)
    }
    
    /// Save daily check-in
    func saveCheckIn() {
        lastCheckInDate = Date()
        totalReplacements += replacementsCount
        completedCheckIns += 1
        
        // Update streak
        if replacedToday {
            currentStreak += 1
        } else {
            currentStreak = 0
        }
        
        print("✅ Check-in saved: \(replacementsCount) swaps, craving: \(Int(cravingLevel))/10")
        // TODO: Persist to storage
    }
    
    /// Reset daily check-in state
    func resetDailyCheckIn() {
        replacedToday = false
        replacementsCount = 0
        cravingLevel = 5.0
    }
    
    /// Update ranking order
    func updateRanking(_ foods: [RankedFood]) {
        rankedFoods = foods
        // TODO: Persist ranking
    }
    
    // MARK: - Private Helpers
    
    private func loadDefaultCombos() {
        // Load default combos from MockDataService
        activeCombos = MockDataService.swaps(for: .soda)
    }
}

