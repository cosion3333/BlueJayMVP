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
    let id: String
    let targetFoodId: String  // Links to BadFood.id
    let title: String
    let description: String
    let foods: [String]
    
    init(id: String? = nil,
         targetFoodId: String,
         title: String,
         description: String,
         foods: [String]) {
        self.id = id ?? SwapCombo.makeStableID(
            targetFoodId: targetFoodId,
            title: title,
            foods: foods
        )
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
        self.targetFoodId = try container.decode(String.self, forKey: .targetFoodId)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.foods = try container.decode([String].self, forKey: .foods)
        
        if let stringID = try? container.decode(String.self, forKey: .id),
           !stringID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.id = stringID
        } else {
            self.id = SwapCombo.makeStableID(
                targetFoodId: targetFoodId,
                title: title,
                foods: foods
            )
        }
    }
    
    private static func makeStableID(targetFoodId: String, title: String, foods: [String]) -> String {
        let normalizedTitle = normalize(title)
        let normalizedFoods = foods.map(normalize).joined(separator: "-")
        return "\(targetFoodId)__\(normalizedTitle)__\(normalizedFoods)"
    }
    
    private static func normalize(_ text: String) -> String {
        text
            .lowercased()
            .replacingOccurrences(of: "[^a-z0-9]+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }
    
    // Smart emoji detection based on swap contents - shows 2 key emojis
    var emoji: String {
        var emojis: [String] = []
        let titleLower = title.lowercased()
        let allFoods = foods.joined(separator: " ").lowercased()
        
        // Proteins (highest priority - show first)
        if titleLower.contains("chicken") || allFoods.contains("chicken") { emojis.append("🍗") }
        if titleLower.contains("salmon") || allFoods.contains("salmon") { emojis.append("🐟") }
        if titleLower.contains("tuna") || allFoods.contains("tuna") { emojis.append("🐟") }
        if titleLower.contains("beef") || allFoods.contains("beef") { emojis.append("🥩") }
        if titleLower.contains("egg") || allFoods.contains("egg") { emojis.append("🥚") }
        
        // Dairy/Protein alternatives
        if titleLower.contains("yogurt") || allFoods.contains("yogurt") { emojis.append("🥣") }
        if titleLower.contains("cottage") { emojis.append("🧀") }
        if titleLower.contains("ricotta") { emojis.append("🧈") }
        if titleLower.contains("cheese") && emojis.isEmpty { emojis.append("🧀") }
        
        // Vegetables
        if titleLower.contains("broccoli") { emojis.append("🥦") }
        if titleLower.contains("spinach") || titleLower.contains("kale") || titleLower.contains("arugula") { emojis.append("🥬") }
        if titleLower.contains("tomato") { emojis.append("🍅") }
        if titleLower.contains("avocado") || allFoods.contains("avocado") { emojis.append("🥑") }
        if titleLower.contains("cucumber") { emojis.append("🥒") }
        if titleLower.contains("carrot") { emojis.append("🥕") }
        if titleLower.contains("mushroom") { emojis.append("🍄") }
        if titleLower.contains("pepper") { emojis.append("🫑") }
        if titleLower.contains("corn") { emojis.append("🌽") }
        
        // Fruits
        if titleLower.contains("apple") || allFoods.contains("apple") { emojis.append("🍎") }
        if titleLower.contains("strawberr") { emojis.append("🍓") }
        if titleLower.contains("blueberr") { emojis.append("🫐") }
        if titleLower.contains("berr") || allFoods.contains("berr") { emojis.append("🫐") }
        if titleLower.contains("mango") || allFoods.contains("mango") { emojis.append("🥭") }
        if titleLower.contains("orange") { emojis.append("🍊") }
        if titleLower.contains("lemon") { emojis.append("🍋") }
        if titleLower.contains("banana") { emojis.append("🍌") }
        if titleLower.contains("cherr") { emojis.append("🍒") }
        if titleLower.contains("fig") { emojis.append("🫒") }
        if titleLower.contains("melon") { emojis.append("🍈") }
        
        // Grains
        if titleLower.contains("quinoa") || allFoods.contains("quinoa") { emojis.append("🍚") }
        if titleLower.contains("rice") { emojis.append("🍚") }
        if titleLower.contains("oatmeal") || allFoods.contains("oatmeal") { emojis.append("🥣") }
        
        // Nuts
        if titleLower.contains("nut") || titleLower.contains("almond") || titleLower.contains("walnut") || titleLower.contains("pecan") || titleLower.contains("cashew") { emojis.append("🥜") }
        
        // Drinks
        if titleLower.contains("seltzer") || titleLower.contains("sparkling") || titleLower.contains("water") { emojis.append("💧") }
        if titleLower.contains("coffee") { emojis.append("☕") }
        if titleLower.contains("tea") { emojis.append("🍵") }
        
        // Other
        if titleLower.contains("chocolate") { emojis.append("🍫") }
        if titleLower.contains("hummus") { emojis.append("🥙") }
        if titleLower.contains("olive") { emojis.append("🫒") }
        if titleLower.contains("edamame") { emojis.append("🫛") }
        
        // Return first 2 unique emojis
        let uniqueEmojis = Array(NSOrderedSet(array: emojis)) as! [String]
        let limitedEmojis = Array(uniqueEmojis.prefix(2))
        
        return limitedEmojis.isEmpty ? "🍽️" : limitedEmojis.joined()
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

