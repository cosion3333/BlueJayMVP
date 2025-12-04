//
//  SwapEngine.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 11/25/25.
//

import Foundation

/// Business logic for swap recommendations, filtering, and matching
struct SwapEngine {
    
    // MARK: - Food Matching
    
    /// Find which TargetFood a food item matches (if any)
    static func detectTargetFood(from foodName: String) -> TargetFood? {
        let normalized = foodName.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Fries detection
        if normalized.contains("fries") || normalized.contains("french fries") {
            return .fries
        }
        
        // Soda detection
        if normalized.contains("soda") || 
           normalized.contains("coke") || 
           normalized.contains("pepsi") ||
           normalized.contains("sprite") ||
           normalized.contains("cola") {
            return .soda
        }
        
        // Chips detection
        if normalized.contains("chips") || 
           normalized.contains("potato chips") ||
           normalized.contains("doritos") ||
           normalized.contains("lays") {
            return .chips
        }
        
        return nil
    }
    
    /// Get swap recommendations for a food item
    static func recommendSwaps(for foodName: String) -> [SwapCombo] {
        guard let target = detectTargetFood(from: foodName) else {
            return []
        }
        return MockDataService.swaps(for: target)
    }
    
    // MARK: - Filtering & Search
    
    /// Filter suggested foods based on search query
    static func filterSuggestions(query: String) -> [String] {
        guard !query.isEmpty else {
            return MockDataService.suggestedFoods
        }
        
        let normalized = query.lowercased()
        return MockDataService.suggestedFoods.filter { food in
            food.lowercased().contains(normalized)
        }
    }
    
    /// Get top suggestions (limited results for typeahead)
    static func getTopSuggestions(query: String, limit: Int = 5) -> [String] {
        let filtered = filterSuggestions(query: query)
        return Array(filtered.prefix(limit))
    }
    
    // MARK: - Ranking & Scoring
    
    /// Score a swap based on calorie drop (higher = better)
    static func scoreSwap(_ swap: SwapCombo) -> Int {
        return swap.estKcalDrop
    }
    
    /// Get best swap for a target food (highest calorie drop)
    static func getBestSwap(for target: TargetFood) -> SwapCombo? {
        let swaps = MockDataService.swaps(for: target)
        return swaps.max(by: { scoreSwap($0) < scoreSwap($1) })
    }
    
    /// Rank swaps by effectiveness
    static func rankedSwaps(for target: TargetFood) -> [SwapCombo] {
        let swaps = MockDataService.swaps(for: target)
        return swaps.sorted { scoreSwap($0) > scoreSwap($1) }
    }
    
    // MARK: - Analysis
    
    /// Analyze recall items and detect potential swaps
    static func analyzeRecall(_ items: [String]) -> [TargetFood: [SwapCombo]] {
        var results: [TargetFood: [SwapCombo]] = [:]
        
        for item in items where !item.isEmpty {
            if let target = detectTargetFood(from: item) {
                results[target] = MockDataService.swaps(for: target)
            }
        }
        
        return results
    }
    
    /// Calculate total potential calorie savings from swaps
    static func calculatePotentialSavings(swaps: [SwapCombo]) -> Int {
        return swaps.reduce(0) { $0 + $1.estKcalDrop }
    }
    
    /// Get summary of swap opportunities from recall
    static func getSwapSummary(from recallItems: [String]) -> String {
        let analysis = analyzeRecall(recallItems)
        
        guard !analysis.isEmpty else {
            return "No swap opportunities detected."
        }
        
        let targetCount = analysis.keys.count
        let totalSwaps = analysis.values.flatMap { $0 }.count
        let potentialSavings = calculatePotentialSavings(
            swaps: analysis.values.flatMap { $0 }
        )
        
        return "\(targetCount) target food(s) found • \(totalSwaps) swap(s) available • ~\(potentialSavings) kcal potential savings"
    }
}

