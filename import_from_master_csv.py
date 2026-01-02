#!/usr/bin/env python3
"""
Import master CSV back to bluejay_data.json
Usage: ./import_from_master_csv.py
Input: bluejay_master.csv from your Desktop
Output: Updates BlueJayMVP/Resources/bluejay_data.json
"""

import json
import csv
from pathlib import Path
from collections import defaultdict

# Paths
desktop = Path.home() / "Desktop"
master_csv = desktop / "bluejay_master.csv"
json_file = Path(__file__).parent / "BlueJayMVP/Resources/bluejay_data.json"

# Check if CSV exists
if not master_csv.exists():
    print(f"❌ Error: {master_csv} not found!")
    print(f"   Run ./export_to_master_csv.py first")
    exit(1)

# Load from master CSV
foods_dict = {}  # id -> food data
swaps_list = []

with open(master_csv, 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        # Extract target food (de-duplicate by id)
        target_id = row['target_id']
        if target_id not in foods_dict:
            foods_dict[target_id] = {
                'id': target_id,
                'name': row['target_name'],
                'category': row['target_category'],
                'keywords': row['target_keywords'].split('|'),
                'avgCalories': int(row['target_calories']),
                'priority': int(row['target_priority'])
            }
        
        # Extract swap
        swaps_list.append({
            'targetFoodId': target_id,
            'title': row['swap_title'],
            'description': row['swap_description'],
            'foods': row['swap_foods'].split('|')
        })

# Convert dict to list and sort by priority
foods_list = sorted(foods_dict.values(), key=lambda x: x['priority'])

print(f"✅ Loaded {len(foods_list)} unique targets from CSV")
print(f"✅ Loaded {len(swaps_list)} swaps from CSV")

# Combine and save to JSON
data = {
    'badFoods': foods_list,
    'swaps': swaps_list
}

with open(json_file, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2)

print(f"✅ Updated {json_file}")
print(f"\n🚀 Done! Run your app to see the changes")

