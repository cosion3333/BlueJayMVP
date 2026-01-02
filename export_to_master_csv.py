#!/usr/bin/env python3
"""
Export bluejay_data.json to a SINGLE master CSV file for easy editing
Usage: ./export_to_master_csv.py
Output: bluejay_master.csv on your Desktop (one row per swap with target info)
"""

import json
import csv
from pathlib import Path

# Paths
json_file = Path(__file__).parent / "BlueJayMVP/Resources/bluejay_data.json"
desktop = Path.home() / "Desktop"
master_csv = desktop / "bluejay_master.csv"

# Load JSON
with open(json_file, 'r') as f:
    data = json.load(f)

# Create lookup for bad foods
foods_by_id = {food['id']: food for food in data['badFoods']}

# Export Combined Master (one row per swap)
with open(master_csv, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    
    # Header
    writer.writerow([
        'target_id',
        'target_name', 
        'target_category',
        'target_keywords',
        'target_calories',
        'target_priority',
        'swap_title',
        'swap_description',
        'swap_foods'
    ])
    
    # Write each swap with its target food info
    for swap in data['swaps']:
        target = foods_by_id[swap['targetFoodId']]
        writer.writerow([
            target['id'],
            target['name'],
            target['category'],
            '|'.join(target['keywords']),
            target['avgCalories'],
            target['priority'],
            swap['title'],
            swap['description'],
            '|'.join(swap['foods'])
        ])

print(f"✅ Exported {len(data['swaps'])} swaps to: {master_csv}")
print(f"\n📊 Master file structure:")
print(f"   • 120 rows (one per swap)")
print(f"   • Columns 1-6: Target food info")
print(f"   • Columns 7-9: Swap info")
print(f"\n✏️  In Excel you can:")
print(f"   • See all swaps for each target together")
print(f"   • Sort by priority (column 6)")
print(f"   • Filter by category (column 3)")
print(f"   • Add/delete swaps easily")
print(f"\n🔄 When done editing: ./import_from_master_csv.py")

