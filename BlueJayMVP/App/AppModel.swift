//
//  AppModel.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 11/25/25.
//

import Foundation
import SwiftUI

/// Central app state manager - single source of truth for app-wide data
@Observable
class AppModel {
    
    // MARK: - Recall State
    var recallItems: [String] = Array(repeating: "", count: 6)
    var searchText: String = ""
    
    // MARK: - Ranking State
    var rankedFoods: [RankedFood] = []
    
    // MARK: - Combos State
    var activeCombos: [SwapCombo] = []
    var selectedTargetFood: TargetFood?
    
    // MARK: - Analysis State (Golden Path)
    var detectedFoods: [TargetFood] = []  // Foods detected from recall
    var analysisComplete: Bool = false
    var focusedFood: TargetFood?  // The food user wants to focus on swapping
    
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
        loadPersistedData()
        loadDefaultCombos()
    }
    
    // MARK: - Actions
    
    /// Save recall items
    func saveRecall() {
        PersistenceService.saveRecallItems(recallItems)
        print("📝 Saved recall items: \(recallItems.filter { !$0.isEmpty })")
    }
    
    /// Analyze recall items and detect swappable foods (Golden Path Step 1)
    func analyzeRecall() {
        let analysis = SwapEngine.analyzeRecall(recallItems)
        detectedFoods = Array(analysis.keys).sorted { $0.rawValue < $1.rawValue }
        analysisComplete = !detectedFoods.isEmpty
        
        // Persist detected foods
        PersistenceService.saveDetectedFoods(detectedFoods)
        
        print("🔍 Analysis complete: Found \(detectedFoods.count) swappable food(s)")
    }
    
    /// Set focus on a specific food to swap (Golden Path Step 2)
    func setFocus(on food: TargetFood) {
        focusedFood = food
        loadSwaps(for: food)
        
        // Persist focused food
        PersistenceService.saveFocusedFood(food)
        
        print("🎯 Focus set on: \(food.rawValue)")
    }
    
    /// Load suggested swaps for a target food
    func loadSwaps(for target: TargetFood) {
        selectedTargetFood = target
        activeCombos = MockDataService.swaps(for: target)
        PersistenceService.saveSelectedTargetFood(target)
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
        
        // Persist all check-in and progress data
        PersistenceService.saveCheckInState(
            replacedToday: replacedToday,
            replacementsCount: replacementsCount,
            cravingLevel: cravingLevel
        )
        PersistenceService.saveLastCheckInDate(lastCheckInDate)
        PersistenceService.saveProgressStats(
            streak: currentStreak,
            totalReplacements: totalReplacements,
            completedCheckIns: completedCheckIns
        )
        
        print("✅ Check-in saved: \(replacementsCount) swaps, craving: \(Int(cravingLevel))/10")
    }
    
    /// Reset daily check-in state
    func resetDailyCheckIn() {
        replacedToday = false
        replacementsCount = 0
        cravingLevel = 5.0
        
        PersistenceService.saveCheckInState(
            replacedToday: replacedToday,
            replacementsCount: replacementsCount,
            cravingLevel: cravingLevel
        )
    }
    
    /// Update ranking order
    func updateRanking(_ foods: [RankedFood]) {
        rankedFoods = foods
        PersistenceService.saveRankedFoods(foods)
    }
    
    // MARK: - Private Helpers
    
    /// Load all persisted data from UserDefaults
    private func loadPersistedData() {
        // Load recall items
        recallItems = PersistenceService.loadRecallItems()
        
        // Load ranked foods or set defaults
        if let savedFoods = PersistenceService.loadRankedFoods() {
            rankedFoods = savedFoods
        } else {
            // First launch - set defaults
            rankedFoods = [
                .init(name: "Sugary soda", priority: 1),
                .init(name: "Chips at night", priority: 2),
                .init(name: "Drive-thru breakfast", priority: 3)
            ]
        }
        
        // Load target food selection
        selectedTargetFood = PersistenceService.loadSelectedTargetFood()
        
        // Load Golden Path state
        detectedFoods = PersistenceService.loadDetectedFoods()
        focusedFood = PersistenceService.loadFocusedFood()
        
        // Load check-in state
        let checkInState = PersistenceService.loadCheckInState()
        replacedToday = checkInState.replacedToday
        replacementsCount = checkInState.replacementsCount
        cravingLevel = checkInState.cravingLevel
        lastCheckInDate = PersistenceService.loadLastCheckInDate()
        
        // Load progress stats
        let progress = PersistenceService.loadProgressStats()
        currentStreak = progress.streak
        totalReplacements = progress.totalReplacements
        completedCheckIns = progress.completedCheckIns
    }
    
    private func loadDefaultCombos() {
        // Load combos for selected target or default to soda
        let target = selectedTargetFood ?? .soda
        activeCombos = MockDataService.swaps(for: target)
    }
}
