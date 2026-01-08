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

/// A recommended food swap
struct SwapCombo: Identifiable, Codable, Hashable {
    let id: UUID
    let targetFoodId: String  // Links to BadFood.id
    let title: String
    let description: String
    let foods: [String]
    
    init(id: UUID = UUID(),
         targetFoodId: String,
         title: String,
         description: String,
         foods: [String]) {
        self.id = id
        self.targetFoodId = targetFoodId
        self.title = title
        self.description = description
        self.foods = foods
    }
    
    // Custom decoding to generate UUID if not present in JSON
    enum CodingKeys: String, CodingKey {
        case id, targetFoodId, title, description, foods
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
        self.targetFoodId = try container.decode(String.self, forKey: .targetFoodId)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.foods = try container.decode([String].self, forKey: .foods)
    }
    
    // Smart emoji detection based on swap contents - shows single emoji
    var emoji: String {
        let titleLower = title.lowercased()
        let allFoods = foods.joined(separator: " ").lowercased()
        
        // Check title and foods for keywords (return first match)
        if titleLower.contains("yogurt") || allFoods.contains("yogurt") { return "🥣" }
        if titleLower.contains("cottage") { return "🧀" }
        if titleLower.contains("ricotta") { return "🧈" }
        
        // Fruits
        if titleLower.contains("apple") || allFoods.contains("apple") { return "🍎" }
        if titleLower.contains("strawberr") { return "🍓" }
        if titleLower.contains("blueberr") { return "🫐" }
        if titleLower.contains("berr") || allFoods.contains("berr") { return "🫐" }
        if titleLower.contains("mango") || allFoods.contains("mango") { return "🥭" }
        if titleLower.contains("orange") { return "🍊" }
        if titleLower.contains("lemon") { return "🍋" }
        if titleLower.contains("banana") { return "🍌" }
        if titleLower.contains("cherr") { return "🍒" }
        if titleLower.contains("fig") { return "🫒" }
        if titleLower.contains("melon") { return "🍈" }
        
        // Vegetables
        if titleLower.contains("avocado") || allFoods.contains("avocado") { return "🥑" }
        if titleLower.contains("cucumber") { return "🥒" }
        if titleLower.contains("carrot") { return "🥕" }
        if titleLower.contains("tomato") { return "🍅" }
        if titleLower.contains("broccoli") { return "🥦" }
        if titleLower.contains("spinach") || titleLower.contains("kale") || titleLower.contains("arugula") { return "🥬" }
        if titleLower.contains("mushroom") { return "🍄" }
        if titleLower.contains("pepper") { return "🫑" }
        if titleLower.contains("corn") { return "🌽" }
        
        // Proteins
        if titleLower.contains("salmon") || allFoods.contains("salmon") { return "🐟" }
        if titleLower.contains("tuna") || allFoods.contains("tuna") { return "🐟" }
        if titleLower.contains("chicken") || allFoods.contains("chicken") { return "🍗" }
        if titleLower.contains("beef") || allFoods.contains("beef") { return "🥩" }
        if titleLower.contains("egg") || allFoods.contains("egg") { return "🥚" }
        
        // Drinks
        if titleLower.contains("seltzer") || titleLower.contains("sparkling") || titleLower.contains("water") { return "💧" }
        if titleLower.contains("coffee") { return "☕" }
        if titleLower.contains("tea") { return "🍵" }
        
        // Grains
        if titleLower.contains("oatmeal") || allFoods.contains("oatmeal") { return "🥣" }
        if titleLower.contains("quinoa") || allFoods.contains("quinoa") { return "🍚" }
        if titleLower.contains("rice") { return "🍚" }
        
        // Other
        if titleLower.contains("chocolate") { return "🍫" }
        if titleLower.contains("hummus") { return "🥙" }
        if titleLower.contains("olive") { return "🫒" }
        if titleLower.contains("edamame") { return "🫛" }
        if titleLower.contains("nut") || titleLower.contains("almond") || titleLower.contains("walnut") || titleLower.contains("pecan") || titleLower.contains("cashew") { return "🥜" }
        if titleLower.contains("cheese") { return "🧀" }
        
        // Default fallback
        return "🍽️"
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

