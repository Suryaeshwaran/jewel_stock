# JewelStock — Setup

This folder contains the initial scaffold: theme, folder structure, and the
Drift database layer (schema + queries) for JewelStock. It's written as
Dart/Flutter source only — it hasn't been run through `flutter create` /
`flutter pub get` here, so do the following on your machine:

## 1. Turn this into a real Flutter project
From inside this `jewel_stock` folder:
```
flutter create . --platforms=windows,macos
```
This fills in the missing `windows/`, `macos/`, `android/` (ignore),
`.metadata`, etc., without touching the `lib/` and `pubspec.yaml` already here.

## 2. Set CompanyName (Windows) — same lesson as PharmacyApp
Edit `windows/runner/Runner.rc` and set `CompanyName` so the AppData path
doesn't default to `com.example`.

## 3. Add fonts
Fonts are referenced offline (no Google Fonts package). Download and drop
these into `assets/fonts/`:
- Playfair Display: Regular, Medium (500), Bold (700)
- Inter: Regular, Medium (500), SemiBold (600), Bold (700)

(Both are open-source/free — Google Fonts download page has the static
`.ttf` files; just don't add the `google_fonts` *package* dependency.)

## 4. Install packages
```
flutter pub get
```

## 5. Generate Drift code
The database file (`app_database.dart`) uses `part 'app_database.g.dart'`,
which is generated:
```
dart run build_runner build --delete-conflicting-outputs
```
Re-run this any time a table file changes.

## 6. Run
```
flutter run -d windows   # or -d macos
```

On first launch on Windows you'll see the folder-picker screen — pick any
folder and `jewelstock.sqlite` is created there. On macOS (dev) it's placed
silently under Application Support.

---

## What's included so far
- `lib/app/theme/` — dark, gold/platinum "private banking" theme, offline
  serif+sans fonts, no grey text anywhere (opacity-based hierarchy instead)
- `lib/core/database/tables/` — `ItemGroups`, `ItemTypes`, `Ornaments`,
  `StatusHistories`
- `lib/core/database/app_database.dart` — Drift database + all queries
  (watch item types, watch/search/filter ornaments, status-change
  transaction with history logging, type-wise summary rollup)
- `lib/core/database/db_path_service.dart` +
  `lib/core/services/settings_service.dart` — first-run folder picker on
  Windows, remembered path, silent default on macOS
- `lib/features/dashboard/` — placeholder landing screen
- `lib/features/settings/.../first_run_picker_screen.dart` — first-run UI
- `lib/main.dart` / `lib/app/app.dart` — bootstraps DB path resolution,
  then wires `AppDatabase` through Provider

## Not built yet (next steps)
- Item Type management screen (add/edit/delete)
- Add Ornament form
- Ornament List screen (All/Available/Sold/Pending/Scrapped tabs + search)
- Status Change dialog
- Summary/rollup screen
- Settings screen (Change Database Location)
