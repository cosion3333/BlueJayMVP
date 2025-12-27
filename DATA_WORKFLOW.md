# BlueJay Data Management

## Your Workflow (CSV Master → JSON)

### Files You Edit (Your Master):
- **`~/Desktop/bad_foods.csv`** - Edit targets here (Excel/Numbers)
- **`~/Desktop/swaps.csv`** - Edit swaps here (Excel/Numbers)

### Files You Never Touch:
- **`BlueJayMVP/Resources/bluejay_data.json`** - Generated (don't edit!)
- **`BlueJayMVP/Services/BadFoodsService.swift`** - Set once (forget it!)

---

## Daily Editing Loop

### Step 1: Export (First Time Only)
```bash
cd /Users/cosminionescu/Dev/BlueJayMVP
./export_to_csv.py
```
This creates your master CSV files on Desktop.

### Step 2: Edit in Excel
1. Open `bad_foods.csv` and `swaps.csv` on your Desktop
2. Make changes:
   - Add/remove targets
   - Reorder priorities
   - Edit swap descriptions
   - Change target assignments
3. Save the CSV files

### Step 3: Update App
```bash
cd /Users/cosminionescu/Dev/BlueJayMVP
./import_from_csv.py
```
This converts your CSV → JSON in the app.

### Step 4: Run App
Run from Xcode - it loads the new JSON automatically!

---

## CSV Format Guide

### bad_foods.csv
```
id,name,category,keywords,avgCalories,priority
sugary_soda,Sugary Soda,drinks,soda|coke|pepsi,150,1
```
- **keywords**: Separate with `|` (pipe)
- **priority**: 1 = worst, 40 = least bad

### swaps.csv
```
targetFoodId,title,description,foods
sugary_soda,Seltzer + Lemon,Refreshing,Seltzer water|Lemon
```
- **targetFoodId**: Must match a food `id`
- **foods**: Separate with `|` (pipe)

---

## Important Rules

### ✅ DO:
- Edit CSV files in Excel
- Save CSV after changes
- Run import script to update app
- Print CSV for paper planning

### ❌ DON'T:
- Edit `bluejay_data.json` manually (it will be overwritten!)
- Edit `BadFoodsService.swift` (no need!)
- Forget to run import script after CSV edits

---

## Troubleshooting

### "Can't find CSV files"
Run `./export_to_csv.py` first to create them.

### "Build fails"
Check your CSV format - make sure:
- No blank rows
- Keywords/foods separated by `|`
- All columns present

### "Lost my changes"
CSV is your master! As long as CSV is saved, you can regenerate JSON anytime.

---

## File Structure

```
📁 Your Mac Desktop
  ├── bad_foods.csv       ← YOUR MASTER (edit here)
  └── swaps.csv           ← YOUR MASTER (edit here)

📁 Xcode Project
  ├── export_to_csv.py    ← Export JSON → CSV
  ├── import_from_csv.py  ← Import CSV → JSON
  └── BlueJayMVP/
      ├── Resources/
      │   └── bluejay_data.json  ← App reads (generated)
      └── Services/
          └── BadFoodsService.swift  ← Loads JSON (set once)
```

---

## Summary

**Source of Truth:** CSV files on your Desktop  
**App Reads:** JSON file (auto-generated from CSV)  
**Your Workflow:** Edit CSV → Run import script → Run app  
**Never Edit:** JSON or Swift code manually

