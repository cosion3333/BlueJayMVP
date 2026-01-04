//
//  BadFoodsService.swift
//  BlueJayMVP
//
//  Complete database of 40 bad foods and 120 swaps - Loaded from JSON
//

import Foundation

struct BadFoodsService {
    
    // MARK: - Data Loading
    
    private static let data: FoodData = {
        // Try to find the JSON file in the bundle
        guard let url = Bundle.main.url(forResource: "bluejay_data", withExtension: "json") else {
            print("❌ Could not find bluejay_data.json in bundle")
            print("Bundle path: \(Bundle.main.bundlePath)")
            print("Resource path: \(Bundle.main.resourcePath ?? "nil")")
            fatalError("Failed to find bluejay_data.json in bundle")
        }
        
        print("✅ Found JSON at: \(url.path)")
        
        // Load the data
        guard let jsonData = try? Data(contentsOf: url) else {
            fatalError("Failed to read bluejay_data.json")
        }
        
        print("✅ Loaded \(jsonData.count) bytes")
        
        // Decode the JSON
        do {
            let foodData = try JSONDecoder().decode(FoodData.self, from: jsonData)
            print("✅ Decoded \(foodData.badFoods.count) foods and \(foodData.swaps.count) swaps")
            return foodData
        } catch {
            print("❌ Decode error: \(error)")
            fatalError("Failed to decode bluejay_data.json: \(error)")
        }
    }()
    
    // MARK: - Public API
    
    /// Get all bad foods (unsorted)
    static func getAllBadFoods() -> [BadFood] {
        return data.badFoods
    }
    
    /// Get all bad foods sorted by priority (worst first)
    static func getAllBadFoodsSortedByPriority() -> [BadFood] {
        return data.badFoods.sorted { $0.priority < $1.priority }
    }
    
    /// Get a specific bad food by ID
    static func getBadFood(byId id: String) -> BadFood? {
        return data.badFoods.first { $0.id == id }
    }
    
    /// Get priority ranking for a food
    static func getPriority(forFoodId id: String) -> Int? {
        return getBadFood(byId: id)?.priority
    }
    
    /// Get top N worst foods
    static func getTopWorstFoods(limit: Int = 10) -> [BadFood] {
        return Array(getAllBadFoodsSortedByPriority().prefix(limit))
    }
    
    /// Detect bad food from user text input
    static func detectBadFood(from text: String) -> BadFood? {
        let normalized = text.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Split input into words for whole-word matching (prevents "pop" matching "popcorn")
        let words = normalized.components(separatedBy: .whitespaces)
        
        return data.badFoods.first { food in
            food.keywords.contains { keyword in
                // Check if any word exactly matches the keyword
                words.contains(keyword.lowercased())
            }
        }
    }
    
    /// Detect all bad foods from a list of text items
    static func detectBadFoods(from items: [String]) -> [BadFood] {
        var detected: [BadFood] = []
        var seenIds = Set<String>()
        
        for item in items where !item.isEmpty {
            if let food = detectBadFood(from: item), !seenIds.contains(food.id) {
                detected.append(food)
                seenIds.insert(food.id)
            }
        }
        
        // Sort by priority (worst first)
        return detected.sorted { $0.priority < $1.priority }
    }
    
    /// Get swaps for a specific bad food
    static func getSwaps(forFoodId foodId: String) -> [SwapCombo] {
        return data.swaps.filter { $0.targetFoodId == foodId }
    }
    
    /// Get all swaps
    static func getAllSwaps() -> [SwapCombo] {
        return data.swaps
    }
    
    /// Get first swap for a food
    static func getBestSwap(forFoodId foodId: String) -> SwapCombo? {
        return getSwaps(forFoodId: foodId).first
    }
}

// MARK: - Data Container

struct FoodData: Codable {
    let badFoods: [BadFood]
    let swaps: [SwapCombo]
}
