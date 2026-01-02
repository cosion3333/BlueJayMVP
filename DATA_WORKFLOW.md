# BlueJay Data Management

## Your Workflow (Single Master CSV → JSON)

### File You Edit (Your Master):
- **`~/Desktop/bluejay_master.csv`** - Edit in Excel/Numbers (all targets + swaps in one file!)

### Files You Never Touch:
- **`BlueJayMVP/Resources/bluejay_data.json`** - Generated (don't edit!)
- **`BlueJayMVP/Services/BadFoodsService.swift`** - Set once (forget it!)

---

## Daily Editing Loop

### Step 1: Export (First Time Only)
```bash
cd /Users/cosminionescu/Dev/BlueJayMVP
./export_to_master_csv.py
```
This creates `bluejay_master.csv` on your Desktop (iCloud).

### Step 2: Edit in Excel
1. Open `bluejay_master.csv` on Desktop
2. You'll see **120 rows** (one per swap) with **9 columns**:
   - **Columns 1-6**: Target food info (id, name, category, keywords, calories, priority)
   - **Columns 7-9**: Swap info (title, description, foods)
3. Make changes:
   - **Add swap**: Copy a row, edit columns 7-9
   - **Delete swap**: Delete row
   - **Reorder priorities**: Sort by column 6, renumber
   - **Change target**: Edit columns 1-6 (same target appears on 3 rows for its 3 swaps)
   - **Move swap to different target**: Change column 1 (target_id)
4. Save the CSV file

### Step 3: Update App
```bash
cd /Users/cosminionescu/Dev/BlueJayMVP
./import_from_master_csv.py
```
This converts your CSV → JSON in the app.

### Step 4: Run App
Run from Xcode - it loads the new JSON automatically!

---

## Master CSV Structure

**120 rows (one per swap) × 9 columns:**

| Column | Name | Example | Edit? |
|--------|------|---------|-------|
| 1 | target_id | `sugary_soda` | Links swap to target |
| 2 | target_name | `Sugary Soda` | Display name |
| 3 | target_category | `drinks` | For filtering |
| 4 | target_keywords | `soda\|coke\|pepsi` | Detection (use `\|` separator) |
| 5 | target_calories | `150` | Reference info |
| 6 | target_priority | `1` | 1=worst, 40=least bad |
| 7 | swap_title | `Seltzer + Lemon` | Short name |
| 8 | swap_description | `Refreshing` | Brief note |
| 9 | swap_foods | `Seltzer water\|Lemon` | Ingredients (use `\|` separator) |

**Note:** Target info (columns 1-6) repeats for each swap. Example:
```
Row 1: sugary_soda, Sugary Soda, drinks, ..., Seltzer + Lemon, ...
Row 2: sugary_soda, Sugary Soda, drinks, ..., Sparkling Water, ...
Row 3: sugary_soda, Sugary Soda, drinks, ..., Iced Tea, ...
Row 4: diet_soda, Diet Soda, drinks, ..., Seltzer + Lemon, ...
```

---

## Common Edits in Excel

### Add a New Swap
1. Find the target's existing swaps (filter by column 2)
2. Copy one row
3. Paste below
4. Edit columns 7-9 only
5. Save

### Delete a Swap
1. Find the row
2. Delete entire row
3. Save

### Change Priority Order
1. Sort by column 6 (target_priority)
2. Renumber column 6 as needed
3. Re-sort to see new order
4. Save

### Add a New Target Food
1. Go to bottom
2. Add 3 new rows (for 3 swaps)
3. Fill all 9 columns
4. Make sure column 1 (target_id) is unique (no spaces, lowercase)
5. Save

### Move Swap to Different Target
1. Find the swap row
2. Change column 1 (target_id) to new target
3. Update columns 2-6 to match new target
4. Save

---

## Important Rules

### ✅ DO:
- Edit CSV file in Excel
- Use `|` (pipe) to separate keywords and foods
- Save CSV after changes
- Run import script to update app
- Print CSV for paper planning
- Keep CSV on iCloud Desktop (auto-backup!)

### ❌ DON'T:
- Edit `bluejay_data.json` manually (it will be overwritten!)
- Edit `BadFoodsService.swift` (no need!)
- Forget to run import script after CSV edits
- Use commas in keywords/foods (breaks CSV - use pipe `|` instead)

---

## iCloud Desktop Notes

Your CSV is in `~/Desktop/` which syncs to iCloud:
- ✅ **Auto backup** - Never lose your data
- ✅ **Version history** - Right-click → Revert To
- ⚠️ **Wait 2-3 seconds** after saving before running import (let iCloud sync)

---

## Troubleshooting

### "Can't find CSV file"
Run `./export_to_master_csv.py` first to create it.

### "Build fails"
Check your CSV format:
- Use `|` not `,` for separating keywords/foods
- No blank rows
- All 9 columns present

### "Lost my changes"
CSV is your master! As long as CSV is saved, you can regenerate JSON anytime.

### "Excel created weird files"
Ignore temp files like `~$bluejay_master.csv` - they disappear when you close Excel.

---

## File Structure

```
📁 Your Mac Desktop (iCloud)
  └── bluejay_master.csv       ← YOUR MASTER (edit here)

📁 Xcode Project
  ├── export_to_master_csv.py  ← Export JSON → CSV (one-time)
  ├── import_from_master_csv.py ← Import CSV → JSON (daily)
  └── BlueJayMVP/
      ├── Resources/
      │   └── bluejay_data.json  ← App reads (generated)
      └── Services/
          └── BadFoodsService.swift  ← Loads JSON (set once)
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Create master CSV | `./export_to_master_csv.py` |
| Update app from CSV | `./import_from_master_csv.py` |
| Find CSV file | `~/Desktop/bluejay_master.csv` |
| Open in Excel | Double-click CSV on Desktop |

---

## Summary

**Source of Truth:** `bluejay_master.csv` on your Desktop  
**App Reads:** `bluejay_data.json` (auto-generated from CSV)  
**Your Workflow:** Edit CSV → Run import script → Run app  
**Never Edit:** JSON or Swift code manually  
**Backup:** Automatic (iCloud Desktop)
