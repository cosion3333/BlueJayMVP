//
//  PersistenceService.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 11/30/25.
//

import Foundation

/// Handles local persistence using UserDefaults
struct PersistenceService {
    
    private static let defaults = UserDefaults.standard
    
    // MARK: - Storage Keys
    
    private enum Keys {
        static let recallItems = "recall_items"
        static let rankedFoods = "ranked_foods"
        static let selectedTargetFood = "selected_target_food"
        static let replacedToday = "replaced_today"
        static let replacementsCount = "replacements_count"
        static let cravingLevel = "craving_level"
        static let lastCheckInDate = "last_check_in_date"
        static let currentStreak = "current_streak"
        static let totalReplacements = "total_replacements"
        static let completedCheckIns = "completed_check_ins"
    }
    
    // MARK: - Recall
    
    static func saveRecallItems(_ items: [String]) {
        defaults.set(items, forKey: Keys.recallItems)
    }
    
    static func loadRecallItems() -> [String] {
        return defaults.stringArray(forKey: Keys.recallItems) ?? Array(repeating: "", count: 6)
    }
    
    // MARK: - Ranking
    
    static func saveRankedFoods(_ foods: [RankedFood]) {
        if let encoded = try? JSONEncoder().encode(foods) {
            defaults.set(encoded, forKey: Keys.rankedFoods)
        }
    }
    
    static func loadRankedFoods() -> [RankedFood]? {
        guard let data = defaults.data(forKey: Keys.rankedFoods),
              let foods = try? JSONDecoder().decode([RankedFood].self, from: data) else {
            return nil
        }
        return foods
    }
    
    // MARK: - Target Food Selection
    
    static func saveSelectedTargetFood(_ target: TargetFood?) {
        defaults.set(target?.rawValue, forKey: Keys.selectedTargetFood)
    }
    
    static func loadSelectedTargetFood() -> TargetFood? {
        guard let rawValue = defaults.string(forKey: Keys.selectedTargetFood) else {
            return nil
        }
        return TargetFood(rawValue: rawValue)
    }
    
    // MARK: - Check-In State
    
    static func saveCheckInState(replacedToday: Bool, replacementsCount: Int, cravingLevel: Double) {
        defaults.set(replacedToday, forKey: Keys.replacedToday)
        defaults.set(replacementsCount, forKey: Keys.replacementsCount)
        defaults.set(cravingLevel, forKey: Keys.cravingLevel)
    }
    
    static func loadCheckInState() -> (replacedToday: Bool, replacementsCount: Int, cravingLevel: Double) {
        let replacedToday = defaults.bool(forKey: Keys.replacedToday)
        let replacementsCount = defaults.integer(forKey: Keys.replacementsCount)
        let cravingLevel = defaults.double(forKey: Keys.cravingLevel)
        return (replacedToday, replacementsCount, cravingLevel == 0 ? 5.0 : cravingLevel)
    }
    
    static func saveLastCheckInDate(_ date: Date?) {
        defaults.set(date, forKey: Keys.lastCheckInDate)
    }
    
    static func loadLastCheckInDate() -> Date? {
        return defaults.object(forKey: Keys.lastCheckInDate) as? Date
    }
    
    // MARK: - Progress Stats
    
    static func saveProgressStats(streak: Int, totalReplacements: Int, completedCheckIns: Int) {
        defaults.set(streak, forKey: Keys.currentStreak)
        defaults.set(totalReplacements, forKey: Keys.totalReplacements)
        defaults.set(completedCheckIns, forKey: Keys.completedCheckIns)
    }
    
    static func loadProgressStats() -> (streak: Int, totalReplacements: Int, completedCheckIns: Int) {
        let streak = defaults.integer(forKey: Keys.currentStreak)
        let totalReplacements = defaults.integer(forKey: Keys.totalReplacements)
        let completedCheckIns = defaults.integer(forKey: Keys.completedCheckIns)
        return (streak, totalReplacements, completedCheckIns)
    }
    
    // MARK: - Reset
    
    /// Clear all persisted data (useful for testing or user logout)
    static func clearAllData() {
        let keys = [
            Keys.recallItems,
            Keys.rankedFoods,
            Keys.selectedTargetFood,
            Keys.replacedToday,
            Keys.replacementsCount,
            Keys.cravingLevel,
            Keys.lastCheckInDate,
            Keys.currentStreak,
            Keys.totalReplacements,
            Keys.completedCheckIns
        ]
        
        keys.forEach { defaults.removeObject(forKey: $0) }
    }
}

