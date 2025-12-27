#!/usr/bin/env python3
"""
Export bluejay_data.json to CSV files for editing
Usage: ./export_to_csv.py
Output: bad_foods.csv and swaps.csv in your Desktop
"""

import json
import csv
import os
from pathlib import Path

# Paths
json_file = Path(__file__).parent / "BlueJayMVP/Resources/bluejay_data.json"
desktop = Path.home() / "Desktop"
foods_csv = desktop / "bad_foods.csv"
swaps_csv = desktop / "swaps.csv"

# Load JSON
with open(json_file, 'r') as f:
    data = json.load(f)

# Export Bad Foods
with open(foods_csv, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['id', 'name', 'category', 'keywords', 'avgCalories', 'priority'])
    
    for food in data['badFoods']:
        writer.writerow([
            food['id'],
            food['name'],
            food['category'],
            '|'.join(food['keywords']),  # Join keywords with |
            food['avgCalories'],
            food['priority']
        ])

print(f"✅ Exported {len(data['badFoods'])} foods to: {foods_csv}")

# Export Swaps
with open(swaps_csv, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['targetFoodId', 'title', 'description', 'foods'])
    
    for swap in data['swaps']:
        writer.writerow([
            swap['targetFoodId'],
            swap['title'],
            swap['description'],
            '|'.join(swap['foods'])  # Join foods with |
        ])

print(f"✅ Exported {len(data['swaps'])} swaps to: {swaps_csv}")
print(f"\n📝 Now you can:")
print(f"   1. Open these CSV files in Excel")
print(f"   2. Edit them (add/remove/reorder)")
print(f"   3. Save")
print(f"   4. Run ./import_from_csv.py to update the app")

