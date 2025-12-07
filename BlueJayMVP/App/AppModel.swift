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
    var recallItems: [String] = []
    var searchText: String = ""
    
    // Helper computed property for non-empty recall items
    var activeRecallItems: [String] {
        recallItems.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }
    
    // MARK: - Ranking State
    var rankedFoods: [RankedFood] = []
    
    // MARK: - Combos State
    var activeCombos: [SwapCombo] = []
    var selectedTargetFood: TargetFood?
    var goToSwap: SwapCombo?  // User's committed swap for current focus
    var swapUsesThisWeek: Int = 0  // Track swap usage
    
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
    
    /// Add a new recall item
    func addRecallItem(_ item: String) {
        let trimmed = item.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        recallItems.append(trimmed)
        print("➕ Added recall item: \(trimmed)")
    }
    
    /// Remove a recall item at index
    func removeRecallItem(at index: Int) {
        guard index >= 0 && index < recallItems.count else { return }
        let removed = recallItems.remove(at: index)
        print("➖ Removed recall item: \(removed)")
    }
    
    /// Save recall items
    func saveRecall() {
        PersistenceService.saveRecallItems(recallItems)
        print("📝 Saved recall items: \(activeRecallItems)")
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
    
    /// Set the user's Go-To swap for current focus
    func setGoToSwap(_ combo: SwapCombo) {
        goToSwap = combo
        PersistenceService.saveGoToSwap(combo)
        print("⭐ Go-To swap set: \(combo.title)")
    }
    
    /// Log that user used their Go-To swap
    func logSwapUse() {
        swapUsesThisWeek += 1
        PersistenceService.saveSwapUsesThisWeek(swapUsesThisWeek)
        print("✅ Swap used! Total this week: \(swapUsesThisWeek)")
    }
    
    /// Reset weekly swap usage (call on Monday)
    func resetWeeklySwapUses() {
        swapUsesThisWeek = 0
        PersistenceService.saveSwapUsesThisWeek(0)
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
        // Load recall items (filter out any empty strings from old format)
        recallItems = PersistenceService.loadRecallItems().filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
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
        
        // Load Go-To swap state
        goToSwap = PersistenceService.loadGoToSwap()
        swapUsesThisWeek = PersistenceService.loadSwapUsesThisWeek()
        
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
