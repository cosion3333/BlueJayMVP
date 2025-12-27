#!/usr/bin/env python3
"""
Import CSV files back to bluejay_data.json
Usage: ./import_from_csv.py
Input: bad_foods.csv and swaps.csv from your Desktop
Output: Updates BlueJayMVP/Resources/bluejay_data.json
"""

import json
import csv
from pathlib import Path

# Paths
desktop = Path.home() / "Desktop"
foods_csv = desktop / "bad_foods.csv"
swaps_csv = desktop / "swaps.csv"
json_file = Path(__file__).parent / "BlueJayMVP/Resources/bluejay_data.json"

# Check if CSV files exist
if not foods_csv.exists():
    print(f"❌ Error: {foods_csv} not found!")
    print(f"   Run ./export_to_csv.py first to create your master CSV files")
    exit(1)

if not swaps_csv.exists():
    print(f"❌ Error: {swaps_csv} not found!")
    print(f"   Run ./export_to_csv.py first to create your master CSV files")
    exit(1)

# Load Bad Foods from CSV
bad_foods = []
with open(foods_csv, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        bad_foods.append({
            'id': row['id'],
            'name': row['name'],
            'category': row['category'],
            'keywords': row['keywords'].split('|'),  # Split by |
            'avgCalories': int(row['avgCalories']),
            'priority': int(row['priority'])
        })

print(f"✅ Loaded {len(bad_foods)} foods from CSV")

# Load Swaps from CSV
swaps = []
with open(swaps_csv, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        swaps.append({
            'targetFoodId': row['targetFoodId'],
            'title': row['title'],
            'description': row['description'],
            'foods': row['foods'].split('|')  # Split by |
        })

print(f"✅ Loaded {len(swaps)} swaps from CSV")

# Combine and save to JSON
data = {
    'badFoods': bad_foods,
    'swaps': swaps
}

with open(json_file, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2)

print(f"✅ Updated {json_file}")
print(f"\n🚀 Done! Run your app to see the changes")

