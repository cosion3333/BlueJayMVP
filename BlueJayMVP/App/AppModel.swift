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
    var recallItems: [String] = [] {
        didSet {
            // Mark analysis as stale if recall changes after analysis
            if analysisComplete && recallItems != oldValue {
                analysisComplete = false
            }
        }
    }
    var searchText: String = ""
    
    // Helper computed property for non-empty recall items
    var activeRecallItems: [String] {
        recallItems.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }
    
    // MARK: - Ranking State
    var rankedFoods: [RankedFood] = []
    
    // MARK: - Analysis State (Updated for new BadFood system)
    var detectedFoods: [BadFood] = []  // Detected bad foods from recall
    var analysisComplete: Bool = false
    var focusedFood: BadFood?  // The bad food user wants to focus on
    
    // MARK: - Combos State
    var activeCombos: [SwapCombo] = []
    var goToSwap: SwapCombo?  // User's committed swap for current focus
    var swapUsesThisWeek: Int = 0  // Track swap usage
    
    // MARK: - Paywall State (RevenueCat Integration)
    var revenueCat: RevenueCatService
    
    /// Check premium status from RevenueCat
    var isPremium: Bool {
        revenueCat.isPremium
    }
    
    var showPaywall: Bool = false  // Controls paywall sheet visibility
    
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
    init(revenueCat: RevenueCatService = .shared) {
        self.revenueCat = revenueCat
        loadPersistedData()
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
    
    /// Analyze recall items and detect bad foods (Golden Path Step 1)
    func analyzeRecall() {
        // Use new BadFoodsService to detect and sort by priority
        detectedFoods = SwapEngine.analyzeRecall(recallItems)
        analysisComplete = !detectedFoods.isEmpty
        
        // Auto-select the worst food (lowest priority) as focus
        if let worstFood = detectedFoods.first {
            setFocus(on: worstFood)  // Use setFocus to set default go-to
        }
        
        // Persist detected foods
        PersistenceService.saveDetectedFoodIds(detectedFoods.map { $0.id })
        
        print("🔍 Analysis complete: Found \(detectedFoods.count) bad food(s)")
        if let focused = focusedFood {
            print("🎯 Auto-selected focus: \(focused.name) (Priority #\(focused.priority))")
        }
    }
    
    /// Set focus on a specific bad food (Golden Path Step 2)
    func setFocus(on food: BadFood) {
        focusedFood = food
        loadSwaps(for: food)
        
        // Set default go-to (first swap) - deterministic behavior
        goToSwap = activeCombos.first
        swapUsesThisWeek = 0
        
        // Persist focused food and go-to
        PersistenceService.saveFocusedFoodId(food.id)
        PersistenceService.saveGoToSwap(goToSwap)
        PersistenceService.saveSwapUsesThisWeek(0)
        
        print("🎯 Focus set on: \(food.name) (Priority #\(food.priority)), Default Go-To: \(goToSwap?.title ?? "none")")
    }
    
    /// Load suggested swaps for a bad food
    func loadSwaps(for food: BadFood) {
        activeCombos = BadFoodsService.getSwaps(forFoodId: food.id)
        print("📋 Loaded \(activeCombos.count) swaps for \(food.name)")
    }
    
    /// Set the user's Go-To swap for current focus
    func setGoToSwap(_ combo: SwapCombo) {
        goToSwap = combo
        PersistenceService.saveGoToSwap(combo)
        print("⭐ Go-To swap set: \(combo.title)")
    }
    
    /// Present paywall with RevenueCat
    func presentPaywall() {
        showPaywall = true
        print("🔒 Paywall triggered")
    }
    
    /// Sync premium status from RevenueCat
    func syncPremiumStatus() {
        revenueCat.syncCustomerInfo()
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
        // Load recall items
        recallItems = PersistenceService.loadRecallItems()
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        // Load ranked foods (legacy)
        if let savedFoods = PersistenceService.loadRankedFoods() {
            rankedFoods = savedFoods
        } else {
            rankedFoods = [
                .init(name: "Sugary soda", priority: 1),
                .init(name: "Chips at night", priority: 2),
                .init(name: "Drive-thru breakfast", priority: 3)
            ]
        }
        
        // Load detected foods (by IDs)
        let detectedIds = PersistenceService.loadDetectedFoodIds()
        detectedFoods = detectedIds.compactMap { BadFoodsService.getBadFood(byId: $0) }
            .sorted { $0.priority < $1.priority }
        
        // Load focused food (by ID)
        if let focusedId = PersistenceService.loadFocusedFoodId(),
           let food = BadFoodsService.getBadFood(byId: focusedId) {
            focusedFood = food
            loadSwaps(for: food)
        }
        
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
}
