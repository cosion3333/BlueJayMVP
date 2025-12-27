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
    
    /// Find which BadFood a food item matches (if any)
    static func detectTargetFood(from foodName: String) -> BadFood? {
        return BadFoodsService.detectBadFood(from: foodName)
    }
    
    /// Get swap recommendations for a food item by name
    static func recommendSwaps(for foodName: String) -> [SwapCombo] {
        guard let badFood = detectTargetFood(from: foodName) else {
            return []
        }
        return BadFoodsService.getSwaps(forFoodId: badFood.id)
    }
    
    /// Get swaps for a specific bad food
    static func getSwaps(for badFood: BadFood) -> [SwapCombo] {
        return BadFoodsService.getSwaps(forFoodId: badFood.id)
    }
    
    // MARK: - Filtering & Search
    
    /// Filter suggested foods based on search query
    static func filterSuggestions(query: String) -> [String] {
        guard !query.isEmpty else {
            return BadFoodsService.getAllBadFoods().map { $0.name }
        }
        
        let normalized = query.lowercased()
        return BadFoodsService.getAllBadFoods()
            .filter { food in
                food.name.lowercased().contains(normalized) ||
                food.keywords.contains { $0.lowercased().contains(normalized) }
            }
            .map { $0.name }
    }
    
    /// Get top suggestions (limited results for typeahead)
    static func getTopSuggestions(query: String, limit: Int = 5) -> [String] {
        let filtered = filterSuggestions(query: query)
        return Array(filtered.prefix(limit))
    }
    
    // MARK: - Ranking & Selection
    
    /// Get first swap for a bad food
    static func getBestSwap(for badFood: BadFood) -> SwapCombo? {
        return BadFoodsService.getBestSwap(forFoodId: badFood.id)
    }
    
    /// Get swaps in order (as defined in service)
    static func rankedSwaps(for badFood: BadFood) -> [SwapCombo] {
        return BadFoodsService.getSwaps(forFoodId: badFood.id)
    }
    
    // MARK: - Analysis
    
    /// Analyze recall items and detect bad foods (returns sorted by priority)
    static func analyzeRecall(_ items: [String]) -> [BadFood] {
        return BadFoodsService.detectBadFoods(from: items)
    }
    
    /// Get the worst detected food (lowest priority number)
    static func getWorstDetectedFood(from detected: [BadFood]) -> BadFood? {
        return detected.min(by: { $0.priority < $1.priority })
    }
    
    /// Get summary of swap opportunities from recall
    static func getSwapSummary(from recallItems: [String]) -> String {
        let detected = analyzeRecall(recallItems)
        
        guard !detected.isEmpty else {
            return "No swap opportunities detected."
        }
        
        let foodCount = detected.count
        let totalSwaps = detected.reduce(0) { count, food in
            count + BadFoodsService.getSwaps(forFoodId: food.id).count
        }
        
        return "\(foodCount) target food(s) found • \(totalSwaps) swap(s) available"
    }
}

