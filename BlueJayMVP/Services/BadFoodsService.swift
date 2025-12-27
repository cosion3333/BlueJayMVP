//
//  BadFoodsService.swift
//  BlueJayMVP
//
//  Complete database of 40 bad foods and 120 swaps
//

import Foundation

struct BadFoodsService {
    
    // MARK: - Bad Foods Data (40 items)
    
    private static let badFoodsData: [BadFood] = [
        BadFood(id: "sugary_soda", name: "Sugary Soda", category: "drinks",
                keywords: ["soda", "coke", "pepsi", "sprite", "pop"],
                avgCalories: 150, priority: 1),
        
        BadFood(id: "diet_soda", name: "Diet Soda", category: "drinks",
                keywords: ["diet soda", "diet coke", "coke zero", "diet pepsi"],
                avgCalories: 0, priority: 2),
        
        BadFood(id: "energy_drinks", name: "Energy Drinks", category: "drinks",
                keywords: ["energy drink", "red bull", "monster", "rockstar"],
                avgCalories: 110, priority: 3),
        
        BadFood(id: "fruit_juice", name: "Fruit Juice", category: "drinks",
                keywords: ["juice", "orange juice", "apple juice", "fruit juice"],
                avgCalories: 120, priority: 4),
        
        BadFood(id: "sweetened_iced_tea", name: "Sweetened Iced Tea / Lemonade", category: "drinks",
                keywords: ["iced tea", "sweet tea", "lemonade", "sweetened tea"],
                avgCalories: 90, priority: 5),
        
        BadFood(id: "specialty_coffee", name: "Specialty Coffee (Frappuccinos)", category: "drinks",
                keywords: ["frappuccino", "latte", "mocha", "specialty coffee", "starbucks"],
                avgCalories: 400, priority: 6),
        
        BadFood(id: "alcohol_beer", name: "Alcohol / Beer", category: "drinks",
                keywords: ["beer", "alcohol", "wine", "liquor"],
                avgCalories: 150, priority: 7),
        
        BadFood(id: "potato_chips", name: "Potato Chips", category: "snacks",
                keywords: ["chips", "potato chips", "lays", "pringles"],
                avgCalories: 152, priority: 8),
        
        BadFood(id: "tortilla_chips", name: "Tortilla Chips (Doritos)", category: "snacks",
                keywords: ["doritos", "tortilla chips", "nacho chips", "tostitos"],
                avgCalories: 140, priority: 9),
        
        BadFood(id: "cheese_puffs", name: "Cheese Puffs (Cheetos)", category: "snacks",
                keywords: ["cheetos", "cheese puffs", "cheese balls"],
                avgCalories: 160, priority: 10),
        
        BadFood(id: "pretzels", name: "Pretzels", category: "snacks",
                keywords: ["pretzels", "pretzel"],
                avgCalories: 110, priority: 11),
        
        BadFood(id: "crackers", name: "Crackers (Saltines/Ritz)", category: "snacks",
                keywords: ["crackers", "ritz", "saltines", "wheat thins"],
                avgCalories: 80, priority: 12),
        
        BadFood(id: "movie_popcorn", name: "Movie Theater Popcorn", category: "snacks",
                keywords: ["popcorn", "movie popcorn", "buttered popcorn"],
                avgCalories: 600, priority: 13),
        
        BadFood(id: "french_fries", name: "French Fries", category: "fried",
                keywords: ["fries", "french fries", "curly fries"],
                avgCalories: 365, priority: 14),
        
        BadFood(id: "onion_rings", name: "Onion Rings", category: "fried",
                keywords: ["onion rings"],
                avgCalories: 410, priority: 15),
        
        BadFood(id: "fried_chicken", name: "Fried Chicken", category: "fried",
                keywords: ["fried chicken", "kfc", "popeyes"],
                avgCalories: 320, priority: 16),
        
        BadFood(id: "chicken_nuggets", name: "Chicken Nuggets", category: "fried",
                keywords: ["chicken nuggets", "nuggets", "mcnuggets"],
                avgCalories: 270, priority: 17),
        
        BadFood(id: "mozzarella_sticks", name: "Mozzarella Sticks", category: "fried",
                keywords: ["mozzarella sticks", "cheese sticks", "fried mozzarella"],
                avgCalories: 280, priority: 18),
        
        BadFood(id: "pizza", name: "Pizza", category: "fast_food",
                keywords: ["pizza", "pizza slice", "dominos", "pizza hut"],
                avgCalories: 285, priority: 19),
        
        BadFood(id: "hot_dogs", name: "Hot Dogs", category: "fast_food",
                keywords: ["hot dog", "hotdog", "hot dogs"],
                avgCalories: 290, priority: 20),
        
        BadFood(id: "hamburgers", name: "Hamburgers (Fast Food)", category: "fast_food",
                keywords: ["hamburger", "burger", "cheeseburger", "big mac"],
                avgCalories: 540, priority: 21),
        
        BadFood(id: "bacon", name: "Bacon", category: "processed_meat",
                keywords: ["bacon", "bacon strips"],
                avgCalories: 43, priority: 22),
        
        BadFood(id: "sausage", name: "Sausage", category: "processed_meat",
                keywords: ["sausage", "breakfast sausage"],
                avgCalories: 300, priority: 23),
        
        BadFood(id: "deli_meats", name: "Deli Meats", category: "processed_meat",
                keywords: ["deli meat", "lunch meat", "salami", "ham", "bologna"],
                avgCalories: 150, priority: 24),
        
        BadFood(id: "instant_ramen", name: "Instant Ramen", category: "processed",
                keywords: ["ramen", "instant noodles", "top ramen"],
                avgCalories: 380, priority: 25),
        
        BadFood(id: "boxed_mac_cheese", name: "Boxed Mac & Cheese", category: "processed",
                keywords: ["mac and cheese", "macaroni", "kraft mac"],
                avgCalories: 350, priority: 26),
        
        BadFood(id: "canned_soup", name: "Canned Soup", category: "processed",
                keywords: ["canned soup", "soup", "campbell's"],
                avgCalories: 200, priority: 27),
        
        BadFood(id: "frozen_dinners", name: "Frozen TV Dinners", category: "processed",
                keywords: ["frozen dinner", "tv dinner", "lean cuisine"],
                avgCalories: 350, priority: 28),
        
        BadFood(id: "white_bread", name: "White Bread", category: "refined_grains",
                keywords: ["white bread", "wonder bread", "sandwich bread"],
                avgCalories: 80, priority: 29),
        
        BadFood(id: "bagels", name: "Bagels", category: "refined_grains",
                keywords: ["bagel", "bagels"],
                avgCalories: 280, priority: 30),
        
        BadFood(id: "pancakes_waffles", name: "Pancakes / Waffles", category: "breakfast",
                keywords: ["pancakes", "waffles", "pancake", "waffle"],
                avgCalories: 350, priority: 31),
        
        BadFood(id: "toaster_pastries", name: "Toaster Pastries (Pop-Tarts)", category: "breakfast",
                keywords: ["pop tarts", "toaster pastries", "pop-tarts"],
                avgCalories: 200, priority: 32),
        
        BadFood(id: "donuts", name: "Donuts", category: "desserts",
                keywords: ["donut", "doughnut", "donuts", "krispy kreme", "dunkin"],
                avgCalories: 250, priority: 33),
        
        BadFood(id: "muffins", name: "Muffins", category: "desserts",
                keywords: ["muffin", "muffins", "blueberry muffin"],
                avgCalories: 420, priority: 34),
        
        BadFood(id: "sugary_cereal", name: "Sugary Cereal", category: "breakfast",
                keywords: ["cereal", "sugary cereal", "frosted flakes", "fruit loops"],
                avgCalories: 150, priority: 35),
        
        BadFood(id: "granola_bars", name: "Granola Bars", category: "snacks",
                keywords: ["granola bar", "granola bars", "nature valley"],
                avgCalories: 140, priority: 36),
        
        BadFood(id: "ice_cream", name: "Ice Cream", category: "desserts",
                keywords: ["ice cream", "gelato", "frozen dessert"],
                avgCalories: 270, priority: 37),
        
        BadFood(id: "cookies", name: "Cookies", category: "desserts",
                keywords: ["cookies", "oreos", "chocolate chip cookies", "cookie"],
                avgCalories: 140, priority: 38),
        
        BadFood(id: "cake_brownies", name: "Cake / Brownies", category: "desserts",
                keywords: ["cake", "brownies", "brownie", "cupcake"],
                avgCalories: 350, priority: 39),
        
        BadFood(id: "candy", name: "Candy (Bars + Gummies)", category: "sweets",
                keywords: ["candy", "chocolate bar", "gummies", "snickers", "m&ms"],
                avgCalories: 200, priority: 40),
    ]
    
    // MARK: - Swap Combos Data (120 items = 40 foods × 3 swaps each)
    
    private static let swapCombosData: [SwapCombo] = [
        // ========== SUGARY SODA (3 swaps) ==========
        SwapCombo(targetFoodId: "sugary_soda",
                  title: "Seltzer + Lemon",
                  description: "Refreshing",
                  foods: ["Seltzer water", "Lemon"]),
        
        SwapCombo(targetFoodId: "sugary_soda",
                  title: "Sparkling Water + Cucumber Slices",
                  description: "Hydrating",
                  foods: ["Sparkling water", "Cucumber"]),
        
        SwapCombo(targetFoodId: "sugary_soda",
                  title: "Unsweetened Iced Tea + Lemon",
                  description: "Natural",
                  foods: ["Unsweetened iced tea", "Lemon"]),
        
        // ========== DIET SODA (3 swaps) ==========
        SwapCombo(targetFoodId: "diet_soda",
                  title: "Seltzer + Lemon",
                  description: "No artificial sweeteners",
                  foods: ["Seltzer water", "Lemon"]),
        
        SwapCombo(targetFoodId: "diet_soda",
                  title: "Herbal Tea + Lemon",
                  description: "Natural flavors",
                  foods: ["Herbal tea", "Lemon"]),
        
        SwapCombo(targetFoodId: "diet_soda",
                  title: "Sparkling Water + Berries",
                  description: "Naturally sweet",
                  foods: ["Sparkling water", "Mixed berries"]),
        
        // ========== ENERGY DRINKS (3 swaps) ==========
        SwapCombo(targetFoodId: "energy_drinks",
                  title: "Black Coffee + Water",
                  description: "Natural caffeine",
                  foods: ["Black coffee", "Water"]),
        
        SwapCombo(targetFoodId: "energy_drinks",
                  title: "Green Tea + Almonds",
                  description: "Sustained energy",
                  foods: ["Green tea", "Almonds"]),
        
        SwapCombo(targetFoodId: "energy_drinks",
                  title: "Unsweetened Iced Tea + Walnuts",
                  description: "Omega-3s",
                  foods: ["Unsweetened iced tea", "Walnuts"]),
        
        // ========== FRUIT JUICE (3 swaps) ==========
        SwapCombo(targetFoodId: "fruit_juice",
                  title: "Whole Orange + Water",
                  description: "More fiber",
                  foods: ["Whole orange", "Water"]),
        
        SwapCombo(targetFoodId: "fruit_juice",
                  title: "Apple + Seltzer",
                  description: "Satisfying crunch",
                  foods: ["Apple", "Seltzer water"]),
        
        SwapCombo(targetFoodId: "fruit_juice",
                  title: "Berries + Sparkling Water",
                  description: "Antioxidants",
                  foods: ["Mixed berries", "Sparkling water"]),
        
        // ========== SWEETENED ICED TEA / LEMONADE (3 swaps) ==========
        SwapCombo(targetFoodId: "sweetened_iced_tea",
                  title: "Unsweetened Iced Tea + Lemon",
                  description: "No sugar",
                  foods: ["Unsweetened iced tea", "Lemon"]),
        
        SwapCombo(targetFoodId: "sweetened_iced_tea",
                  title: "Seltzer + Lemon",
                  description: "Crisp & clean",
                  foods: ["Seltzer water", "Lemon"]),
        
        SwapCombo(targetFoodId: "sweetened_iced_tea",
                  title: "Water + Berries (Infused)",
                  description: "Natural sweetness",
                  foods: ["Water", "Mixed berries"]),
        
        // ========== SPECIALTY COFFEE (3 swaps) ==========
        SwapCombo(targetFoodId: "specialty_coffee",
                  title: "Iced Coffee + Oat Milk",
                  description: "Still creamy",
                  foods: ["Black coffee", "Ice", "Oat milk"]),
        
        SwapCombo(targetFoodId: "specialty_coffee",
                  title: "Coffee + Low-Fat Milk",
                  description: "Protein boost",
                  foods: ["Coffee", "Low-fat milk"]),
        
        SwapCombo(targetFoodId: "specialty_coffee",
                  title: "Coffee + Soy Milk",
                  description: "Plant-based",
                  foods: ["Coffee", "Soy milk"]),
        
        // ========== ALCOHOL / BEER (3 swaps) ==========
        SwapCombo(targetFoodId: "alcohol_beer",
                  title: "Seltzer + Lemon",
                  description: "Social drink alternative",
                  foods: ["Seltzer water", "Lemon"]),
        
        SwapCombo(targetFoodId: "alcohol_beer",
                  title: "Sparkling Water + Berries",
                  description: "Festive",
                  foods: ["Sparkling water", "Mixed berries"]),
        
        SwapCombo(targetFoodId: "alcohol_beer",
                  title: "Herbal Tea + Lemon",
                  description: "Relaxing",
                  foods: ["Herbal tea", "Lemon"]),
        
        // ========== POTATO CHIPS (3 swaps) ==========
        SwapCombo(targetFoodId: "potato_chips",
                  title: "Hummus + Carrots",
                  description: "Crunchy & filling",
                  foods: ["Hummus", "Carrots"]),
        
        SwapCombo(targetFoodId: "potato_chips",
                  title: "Hummus + Cucumber Slices",
                  description: "Refreshing crunch",
                  foods: ["Hummus", "Cucumber"]),
        
        SwapCombo(targetFoodId: "potato_chips",
                  title: "Cottage Cheese + Cherry Tomatoes",
                  description: "High protein",
                  foods: ["Cottage cheese", "Cherry tomatoes"]),
        
        // Continue with remaining swaps (I'll add them all - this is getting long, but I need to include all 120)
        
        // ========== TORTILLA CHIPS (3 swaps) ==========
        SwapCombo(targetFoodId: "tortilla_chips",
                  title: "Avocado (Guac) + Cherry Tomatoes",
                  description: "Healthy fats",
                  foods: ["Avocado", "Cherry tomatoes"]),
        
        SwapCombo(targetFoodId: "tortilla_chips",
                  title: "Hummus + Bell Pepper Strips",
                  description: "Colorful & crunchy",
                  foods: ["Hummus", "Bell peppers"]),
        
        SwapCombo(targetFoodId: "tortilla_chips",
                  title: "Feta + Cucumber Slices",
                  description: "Mediterranean",
                  foods: ["Feta cheese", "Cucumber"]),
        
        // ========== CHEESE PUFFS (3 swaps) ==========
        SwapCombo(targetFoodId: "cheese_puffs",
                  title: "Mozzarella + Cherry Tomatoes",
                  description: "Fresh & cheesy",
                  foods: ["Mozzarella", "Cherry tomatoes"]),
        
        SwapCombo(targetFoodId: "cheese_puffs",
                  title: "Olives + Mozzarella",
                  description: "Savory",
                  foods: ["Olives", "Mozzarella"]),
        
        SwapCombo(targetFoodId: "cheese_puffs",
                  title: "Goat Cheese + Apple Slices",
                  description: "Sweet & tangy",
                  foods: ["Goat cheese", "Apple"]),
        
        // ========== PRETZELS (3 swaps) ==========
        SwapCombo(targetFoodId: "pretzels",
                  title: "Boiled Eggs + Avocado",
                  description: "Protein-rich",
                  foods: ["Boiled eggs", "Avocado"]),
        
        SwapCombo(targetFoodId: "pretzels",
                  title: "Hummus + Bell Pepper Strips",
                  description: "Light & crunchy",
                  foods: ["Hummus", "Bell peppers"]),
        
        SwapCombo(targetFoodId: "pretzels",
                  title: "Greek Yogurt + Almonds",
                  description: "High protein",
                  foods: ["Greek yogurt", "Almonds"]),
        
        // ========== CRACKERS (3 swaps) ==========
        SwapCombo(targetFoodId: "crackers",
                  title: "Ricotta + Figs",
                  description: "Sweet & creamy",
                  foods: ["Ricotta cheese", "Figs"]),
        
        SwapCombo(targetFoodId: "crackers",
                  title: "Goat Cheese + Apple Slices",
                  description: "Satisfying",
                  foods: ["Goat cheese", "Apple"]),
        
        SwapCombo(targetFoodId: "crackers",
                  title: "Hummus + Cucumber",
                  description: "Light",
                  foods: ["Hummus", "Cucumber"]),
        
        // ========== MOVIE THEATER POPCORN (3 swaps) ==========
        SwapCombo(targetFoodId: "movie_popcorn",
                  title: "Edamame + Cherry Tomatoes",
                  description: "Protein-packed",
                  foods: ["Edamame", "Cherry tomatoes"]),
        
        SwapCombo(targetFoodId: "movie_popcorn",
                  title: "Olives + Mozzarella",
                  description: "Savory",
                  foods: ["Olives", "Mozzarella"]),
        
        SwapCombo(targetFoodId: "movie_popcorn",
                  title: "Cottage Cheese + Berries",
                  description: "Sweet & filling",
                  foods: ["Cottage cheese", "Mixed berries"]),
        
        // ========== FRENCH FRIES (3 swaps) ==========
        SwapCombo(targetFoodId: "french_fries",
                  title: "Chicken + Brown Rice + Mushrooms + Broccoli",
                  description: "Balanced meal",
                  foods: ["Grilled chicken", "Brown rice", "Mushrooms", "Broccoli"]),
        
        SwapCombo(targetFoodId: "french_fries",
                  title: "Salmon + Quinoa + Kale + Cherry Tomatoes",
                  description: "Omega-3 rich",
                  foods: ["Salmon", "Quinoa", "Kale", "Cherry tomatoes"]),
        
        SwapCombo(targetFoodId: "french_fries",
                  title: "Tuna + Quinoa + Cucumbers + Olives",
                  description: "Mediterranean",
                  foods: ["Tuna", "Quinoa", "Cucumbers", "Olives"]),
        
        // ========== ONION RINGS (3 swaps) ==========
        SwapCombo(targetFoodId: "onion_rings",
                  title: "Chicken + Farro + Mushrooms + Spinach",
                  description: "Hearty",
                  foods: ["Grilled chicken", "Farro", "Mushrooms", "Spinach"]),
        
        SwapCombo(targetFoodId: "onion_rings",
                  title: "Lean Beef + Broccoli + Brown Rice + Mushrooms",
                  description: "Iron-rich",
                  foods: ["Lean beef", "Broccoli", "Brown rice", "Mushrooms"]),
        
        SwapCombo(targetFoodId: "onion_rings",
                  title: "Shrimp + Quinoa + Cucumbers + Cherry Tomatoes",
                  description: "Light & fresh",
                  foods: ["Shrimp", "Quinoa", "Cucumbers", "Cherry tomatoes"]),
        
        // ========== FRIED CHICKEN (3 swaps) ==========
        SwapCombo(targetFoodId: "fried_chicken",
                  title: "Chicken + Quinoa + Spinach + Feta",
                  description: "High protein",
                  foods: ["Grilled chicken", "Quinoa", "Spinach", "Feta"]),
        
        SwapCombo(targetFoodId: "fried_chicken",
                  title: "Chicken + Corn + Chickpeas + Zucchini",
                  description: "Fiber-rich",
                  foods: ["Grilled chicken", "Corn", "Chickpeas", "Zucchini"]),
        
        SwapCombo(targetFoodId: "fried_chicken",
                  title: "Chicken + Avocado + Corn + Tomatoes",
                  description: "Satisfying",
                  foods: ["Grilled chicken", "Avocado", "Corn", "Tomatoes"]),
        
        // ========== CHICKEN NUGGETS (3 swaps) ==========
        SwapCombo(targetFoodId: "chicken_nuggets",
                  title: "Chicken + Brown Rice + Broccoli + Mozzarella",
                  description: "Kid-friendly",
                  foods: ["Grilled chicken", "Brown rice", "Broccoli", "Mozzarella"]),
        
        SwapCombo(targetFoodId: "chicken_nuggets",
                  title: "Chicken + Couscous + Avocado + Corn",
                  description: "Tasty & filling",
                  foods: ["Grilled chicken", "Couscous", "Avocado", "Corn"]),
        
        SwapCombo(targetFoodId: "chicken_nuggets",
                  title: "Chicken + Mushrooms + Quinoa + Ricotta",
                  description: "Protein-packed",
                  foods: ["Grilled chicken", "Mushrooms", "Quinoa", "Ricotta"]),
        
        // ========== MOZZARELLA STICKS (3 swaps) ==========
        SwapCombo(targetFoodId: "mozzarella_sticks",
                  title: "Mozzarella + Tomatoes + Arugula + Olives",
                  description: "Fresh Italian",
                  foods: ["Mozzarella", "Tomatoes", "Arugula", "Olives"]),
        
        SwapCombo(targetFoodId: "mozzarella_sticks",
                  title: "Mozzarella + Quinoa + Cherry Tomatoes + Cucumbers",
                  description: "Light & fresh",
                  foods: ["Mozzarella", "Quinoa", "Cherry tomatoes", "Cucumbers"]),
        
        SwapCombo(targetFoodId: "mozzarella_sticks",
                  title: "Feta + Chickpeas + Spinach + Olives",
                  description: "Mediterranean",
                  foods: ["Feta", "Chickpeas", "Spinach", "Olives"]),
        
        // ========== PIZZA (3 swaps) ==========
        SwapCombo(targetFoodId: "pizza",
                  title: "Tuna + Mozzarella + Tomatoes + Olives",
                  description: "Similar flavors",
                  foods: ["Tuna", "Mozzarella", "Tomatoes", "Olives"]),
        
        SwapCombo(targetFoodId: "pizza",
                  title: "Chicken + Feta + Couscous + Olives",
                  description: "Mediterranean twist",
                  foods: ["Grilled chicken", "Feta", "Couscous", "Olives"]),
        
        SwapCombo(targetFoodId: "pizza",
                  title: "Salmon + Avocado + Arugula + Beets",
                  description: "Gourmet option",
                  foods: ["Salmon", "Avocado", "Arugula", "Beets"]),
        
        // ========== HOT DOGS (3 swaps) ==========
        SwapCombo(targetFoodId: "hot_dogs",
                  title: "Turkey + Avocado + Whole-Grain Toast + Tomatoes",
                  description: "Lean protein",
                  foods: ["Turkey breast", "Avocado", "Whole-grain toast", "Tomatoes"]),
        
        SwapCombo(targetFoodId: "hot_dogs",
                  title: "Chicken + Corn + Pinto Beans + Kale",
                  description: "Fiber-rich",
                  foods: ["Grilled chicken", "Corn", "Pinto beans", "Kale"]),
        
        SwapCombo(targetFoodId: "hot_dogs",
                  title: "Tuna + White Beans + Cucumbers + Cherry Tomatoes",
                  description: "Light & fresh",
                  foods: ["Tuna", "White beans", "Cucumbers", "Cherry tomatoes"]),
        
        // ========== HAMBURGERS (3 swaps) ==========
        SwapCombo(targetFoodId: "hamburgers",
                  title: "Lean Beef + Mushrooms + Broccoli + Brown Rice",
                  description: "Still satisfying",
                  foods: ["Lean beef", "Mushrooms", "Broccoli", "Brown rice"]),
        
        SwapCombo(targetFoodId: "hamburgers",
                  title: "Beef + Chickpeas + Spinach + Quinoa",
                  description: "Fiber boost",
                  foods: ["Lean beef", "Chickpeas", "Spinach", "Quinoa"]),
        
        SwapCombo(targetFoodId: "hamburgers",
                  title: "Chicken + Avocado + Feta + Spinach",
                  description: "Lighter option",
                  foods: ["Grilled chicken", "Avocado", "Feta", "Spinach"]),
        
        // ========== BACON (3 swaps) ==========
        SwapCombo(targetFoodId: "bacon",
                  title: "Eggs + Avocado + Spinach + Feta",
                  description: "High protein",
                  foods: ["Eggs", "Avocado", "Spinach", "Feta"]),
        
        SwapCombo(targetFoodId: "bacon",
                  title: "Boiled Eggs + Avocado + Asparagus + Whole-Grain Toast",
                  description: "Satisfying",
                  foods: ["Boiled eggs", "Avocado", "Asparagus", "Whole-grain toast"]),
        
        SwapCombo(targetFoodId: "bacon",
                  title: "Turkey Bacon + Eggs + Spinach + Avocado",
                  description: "Leaner option",
                  foods: ["Turkey bacon", "Eggs", "Spinach", "Avocado"]),
        
        // ========== SAUSAGE (3 swaps) ==========
        SwapCombo(targetFoodId: "sausage",
                  title: "Eggs + Avocado + Mozzarella + Tomatoes",
                  description: "Protein-rich",
                  foods: ["Eggs", "Avocado", "Mozzarella", "Tomatoes"]),
        
        SwapCombo(targetFoodId: "sausage",
                  title: "Eggs + Quinoa + Asparagus + Pesto",
                  description: "Flavorful",
                  foods: ["Eggs", "Quinoa", "Asparagus", "Pesto"]),
        
        SwapCombo(targetFoodId: "sausage",
                  title: "Turkey + Low-Fat Cheddar + Broccoli + Brown Rice",
                  description: "Lean protein",
                  foods: ["Turkey", "Low-fat cheddar", "Broccoli", "Brown rice"]),
        
        // ========== DELI MEATS (3 swaps) ==========
        SwapCombo(targetFoodId: "deli_meats",
                  title: "Tuna + Avocado + Whole Wheat Pita",
                  description: "Omega-3s",
                  foods: ["Tuna", "Avocado", "Whole wheat pita"]),
        
        SwapCombo(targetFoodId: "deli_meats",
                  title: "Chicken + White Beans + Kale + Parmesan",
                  description: "High protein",
                  foods: ["Grilled chicken", "White beans", "Kale", "Parmesan"]),
        
        SwapCombo(targetFoodId: "deli_meats",
                  title: "Salmon + Avocado + Spinach + Edamame",
                  description: "Nutrient-dense",
                  foods: ["Salmon", "Avocado", "Spinach", "Edamame"]),
        
        // ========== INSTANT RAMEN (3 swaps) ==========
        SwapCombo(targetFoodId: "instant_ramen",
                  title: "Miso Soup + Tofu + Mushrooms + Spinach",
                  description: "Much lower sodium",
                  foods: ["Miso soup", "Tofu", "Mushrooms", "Spinach"]),
        
        SwapCombo(targetFoodId: "instant_ramen",
                  title: "Chicken + Wild Rice + Kale + Zucchini",
                  description: "Real food",
                  foods: ["Grilled chicken", "Wild rice", "Kale", "Zucchini"]),
        
        SwapCombo(targetFoodId: "instant_ramen",
                  title: "Tuna + Quinoa + Cauliflower + Olives",
                  description: "Protein-packed",
                  foods: ["Tuna", "Quinoa", "Cauliflower", "Olives"]),
        
        // ========== BOXED MAC & CHEESE (3 swaps) ==========
        SwapCombo(targetFoodId: "boxed_mac_cheese",
                  title: "Cauliflower + Quinoa + Feta + Spinach",
                  description: "Veggie-packed",
                  foods: ["Cauliflower", "Quinoa", "Feta", "Spinach"]),
        
        SwapCombo(targetFoodId: "boxed_mac_cheese",
                  title: "Chicken + Broccoli + Brown Rice + Low-Fat Cheddar",
                  description: "Protein boost",
                  foods: ["Grilled chicken", "Broccoli", "Brown rice", "Low-fat cheddar"]),
        
        SwapCombo(targetFoodId: "boxed_mac_cheese",
                  title: "Tuna + Brown Rice + Mozzarella + Cherry Tomatoes",
                  description: "Still creamy",
                  foods: ["Tuna", "Brown rice", "Mozzarella", "Cherry tomatoes"]),
        
        // ========== CANNED SOUP (3 swaps) ==========
        SwapCombo(targetFoodId: "canned_soup",
                  title: "Kale + White Beans + Olive Oil + Parmesan",
                  description: "Fresh & hearty",
                  foods: ["Kale", "White beans", "Olive oil", "Parmesan"]),
        
        SwapCombo(targetFoodId: "canned_soup",
                  title: "Lentils + Green Beans + Avocado + Chives",
                  description: "Fiber-rich",
                  foods: ["Lentils", "Green beans", "Avocado", "Chives"]),
        
        SwapCombo(targetFoodId: "canned_soup",
                  title: "Chicken + Zucchini + Quinoa + Spinach",
                  description: "Protein-packed",
                  foods: ["Grilled chicken", "Zucchini", "Quinoa", "Spinach"]),
        
        // ========== FROZEN TV DINNERS (3 swaps) ==========
        SwapCombo(targetFoodId: "frozen_dinners",
                  title: "Salmon + Asparagus + Quinoa + Lemon",
                  description: "Fresh ingredients",
                  foods: ["Salmon", "Asparagus", "Quinoa", "Lemon"]),
        
        SwapCombo(targetFoodId: "frozen_dinners",
                  title: "Chicken + Brown Rice + Mushrooms + Broccoli",
                  description: "Balanced meal",
                  foods: ["Grilled chicken", "Brown rice", "Mushrooms", "Broccoli"]),
        
        SwapCombo(targetFoodId: "frozen_dinners",
                  title: "Beef + Green Beans + Orzo + Mushrooms",
                  description: "Hearty",
                  foods: ["Lean beef", "Green beans", "Orzo", "Mushrooms"]),
        
        // ========== WHITE BREAD (3 swaps) ==========
        SwapCombo(targetFoodId: "white_bread",
                  title: "Whole-Grain Toast + Avocado + Eggs",
                  description: "More fiber",
                  foods: ["Whole-grain toast", "Avocado", "Eggs"]),
        
        SwapCombo(targetFoodId: "white_bread",
                  title: "Tuna + Avocado + Whole-Grain Toast",
                  description: "Protein-rich",
                  foods: ["Tuna", "Avocado", "Whole-grain toast"]),
        
        SwapCombo(targetFoodId: "white_bread",
                  title: "Cottage Cheese + Pear + Whole-Grain Toast",
                  description: "Filling",
                  foods: ["Cottage cheese", "Pear", "Whole-grain toast"]),
        
        // ========== BAGELS (3 swaps) ==========
        SwapCombo(targetFoodId: "bagels",
                  title: "Greek Yogurt + Berries + Almonds + Chia Seeds",
                  description: "High protein",
                  foods: ["Greek yogurt", "Mixed berries", "Almonds", "Chia seeds"]),
        
        SwapCombo(targetFoodId: "bagels",
                  title: "Eggs + Avocado + Goat Cheese + Arugula",
                  description: "Savory option",
                  foods: ["Eggs", "Avocado", "Goat cheese", "Arugula"]),
        
        SwapCombo(targetFoodId: "bagels",
                  title: "Cottage Cheese + Cantaloupe + Almonds + Walnuts",
                  description: "Sweet & filling",
                  foods: ["Cottage cheese", "Cantaloupe", "Almonds", "Walnuts"]),
        
        // ========== PANCAKES / WAFFLES (3 swaps) ==========
        SwapCombo(targetFoodId: "pancakes_waffles",
                  title: "Oatmeal + Milk + Walnuts + Berries",
                  description: "Fiber-rich",
                  foods: ["Oatmeal", "Milk", "Walnuts", "Mixed berries"]),
        
        SwapCombo(targetFoodId: "pancakes_waffles",
                  title: "Greek Yogurt + Banana + Walnuts + Chia Seeds",
                  description: "High protein",
                  foods: ["Greek yogurt", "Banana", "Walnuts", "Chia seeds"]),
        
        SwapCombo(targetFoodId: "pancakes_waffles",
                  title: "Eggs + Avocado + Corn + Tomatoes",
                  description: "Savory option",
                  foods: ["Eggs", "Avocado", "Corn", "Tomatoes"]),
        
        // ========== TOASTER PASTRIES (3 swaps) ==========
        SwapCombo(targetFoodId: "toaster_pastries",
                  title: "Quinoa + Milk + Blueberries + Almonds",
                  description: "Protein & fiber",
                  foods: ["Quinoa", "Milk", "Blueberries", "Almonds"]),
        
        SwapCombo(targetFoodId: "toaster_pastries",
                  title: "Oatmeal + Greek Yogurt + Pecans + Apples",
                  description: "Filling",
                  foods: ["Oatmeal", "Greek yogurt", "Pecans", "Apples"]),
        
        SwapCombo(targetFoodId: "toaster_pastries",
                  title: "Cottage Cheese + Apple Slices + Walnuts",
                  description: "High protein",
                  foods: ["Cottage cheese", "Apple", "Walnuts"]),
        
        // ========== DONUTS (3 swaps) ==========
        SwapCombo(targetFoodId: "donuts",
                  title: "Greek Yogurt + Strawberries + Walnuts",
                  description: "Naturally sweet",
                  foods: ["Greek yogurt", "Strawberries", "Walnuts"]),
        
        SwapCombo(targetFoodId: "donuts",
                  title: "Cottage Cheese + Mango + Cashews",
                  description: "Tropical twist",
                  foods: ["Cottage cheese", "Mango", "Cashews"]),
        
        SwapCombo(targetFoodId: "donuts",
                  title: "Ricotta + Figs + Pecans",
                  description: "Gourmet option",
                  foods: ["Ricotta", "Figs", "Pecans"]),
        
        // ========== MUFFINS (3 swaps) ==========
        SwapCombo(targetFoodId: "muffins",
                  title: "Greek Yogurt + Apple Slices + Almonds",
                  description: "Much lighter",
                  foods: ["Greek yogurt", "Apple", "Almonds"]),
        
        SwapCombo(targetFoodId: "muffins",
                  title: "Cottage Cheese + Blueberries + Pecans",
                  description: "High protein",
                  foods: ["Cottage cheese", "Blueberries", "Pecans"]),
        
        SwapCombo(targetFoodId: "muffins",
                  title: "Oatmeal + Milk + Walnuts",
                  description: "Fiber-rich",
                  foods: ["Oatmeal", "Milk", "Walnuts"]),
        
        // ========== SUGARY CEREAL (3 swaps) ==========
        SwapCombo(targetFoodId: "sugary_cereal",
                  title: "Oatmeal + Milk + Walnuts + Berries",
                  description: "No added sugar",
                  foods: ["Oatmeal", "Milk", "Walnuts", "Mixed berries"]),
        
        SwapCombo(targetFoodId: "sugary_cereal",
                  title: "Greek Yogurt + Berries + Almonds + Chia Seeds",
                  description: "High protein",
                  foods: ["Greek yogurt", "Mixed berries", "Almonds", "Chia seeds"]),
        
        SwapCombo(targetFoodId: "sugary_cereal",
                  title: "Cottage Cheese + Cantaloupe + Almonds + Walnuts",
                  description: "Protein-packed",
                  foods: ["Cottage cheese", "Cantaloupe", "Almonds", "Walnuts"]),
        
        // ========== GRANOLA BARS (3 swaps) ==========
        SwapCombo(targetFoodId: "granola_bars",
                  title: "Greek Yogurt + Berries",
                  description: "Fresh & light",
                  foods: ["Greek yogurt", "Mixed berries"]),
        
        SwapCombo(targetFoodId: "granola_bars",
                  title: "Cottage Cheese + Apple Slices",
                  description: "Crunchy & sweet",
                  foods: ["Cottage cheese", "Apple"]),
        
        SwapCombo(targetFoodId: "granola_bars",
                  title: "Almonds + Grapes",
                  description: "On-the-go",
                  foods: ["Almonds", "Grapes"]),
        
        // ========== ICE CREAM (3 swaps) ==========
        SwapCombo(targetFoodId: "ice_cream",
                  title: "Greek Yogurt + Berries",
                  description: "Creamy & sweet",
                  foods: ["Greek yogurt", "Mixed berries"]),
        
        SwapCombo(targetFoodId: "ice_cream",
                  title: "Cottage Cheese + Mango",
                  description: "Tropical treat",
                  foods: ["Cottage cheese", "Mango"]),
        
        SwapCombo(targetFoodId: "ice_cream",
                  title: "Ricotta + Figs",
                  description: "Naturally sweet",
                  foods: ["Ricotta", "Figs"]),
        
        // ========== COOKIES (3 swaps) ==========
        SwapCombo(targetFoodId: "cookies",
                  title: "Apple Slices + Walnuts",
                  description: "Naturally sweet",
                  foods: ["Apple", "Walnuts"]),
        
        SwapCombo(targetFoodId: "cookies",
                  title: "Greek Yogurt + Strawberries",
                  description: "Creamy & light",
                  foods: ["Greek yogurt", "Strawberries"]),
        
        SwapCombo(targetFoodId: "cookies",
                  title: "Cottage Cheese + Blueberries",
                  description: "Protein-rich",
                  foods: ["Cottage cheese", "Blueberries"]),
        
        // ========== CAKE / BROWNIES (3 swaps) ==========
        SwapCombo(targetFoodId: "cake_brownies",
                  title: "Greek Yogurt + Berries",
                  description: "Much lighter",
                  foods: ["Greek yogurt", "Mixed berries"]),
        
        SwapCombo(targetFoodId: "cake_brownies",
                  title: "Cottage Cheese + Cherries",
                  description: "Sweet treat",
                  foods: ["Cottage cheese", "Cherries"]),
        
        SwapCombo(targetFoodId: "cake_brownies",
                  title: "Dark Chocolate + Almonds",
                  description: "Antioxidants",
                  foods: ["Dark chocolate", "Almonds"]),
        
        // ========== CANDY (3 swaps) ==========
        SwapCombo(targetFoodId: "candy",
                  title: "Dark Chocolate + Almonds",
                  description: "Antioxidants",
                  foods: ["Dark chocolate", "Almonds"]),
        
        SwapCombo(targetFoodId: "candy",
                  title: "Berries + Walnuts",
                  description: "Naturally sweet",
                  foods: ["Mixed berries", "Walnuts"]),
        
        SwapCombo(targetFoodId: "candy",
                  title: "Apple Slices + Pecans",
                  description: "Crunchy & sweet",
                  foods: ["Apple", "Pecans"]),
    ]
    
    // MARK: - Public API
    
    /// Get all bad foods (unsorted)
    static func getAllBadFoods() -> [BadFood] {
        return badFoodsData
    }
    
    /// Get all bad foods sorted by priority (worst first)
    static func getAllBadFoodsSortedByPriority() -> [BadFood] {
        return badFoodsData.sorted { $0.priority < $1.priority }
    }
    
    /// Get a specific bad food by ID
    static func getBadFood(byId id: String) -> BadFood? {
        return badFoodsData.first { $0.id == id }
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
        return badFoodsData.first { food in
            food.keywords.contains { normalized.contains($0.lowercased()) }
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
        return swapCombosData.filter { $0.targetFoodId == foodId }
    }
    
    /// Get all swaps
    static func getAllSwaps() -> [SwapCombo] {
        return swapCombosData
    }
    
    /// Get first swap for a food
    static func getBestSwap(forFoodId foodId: String) -> SwapCombo? {
        return getSwaps(forFoodId: foodId).first
    }
}

