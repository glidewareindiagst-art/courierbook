# CourierBook 📦

A Flutter app for managing courier bookings — offline-first with Firebase Phone OTP authentication, local SQLite storage (sqflite), and optional Supabase cloud sync.

---

## Prerequisites

| Tool | Required version |
|------|-----------------|
| Flutter SDK | ≥ 3.x (stable channel) |
| Dart SDK | ≥ 3.9 (bundled with Flutter) |
| Android SDK | API 35 (compileSdk), API 23+ (minSdk) |
| Java | 17 (Temurin recommended) |
| Android Studio / VS Code | Latest |

---

## 1. Flutter SDK Setup (Windows)

```powershell
# Download from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\src\flutter, then add to PATH:
[Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\src\flutter\bin", "User")

# Restart your terminal, then verify:
flutter doctor -v
flutter doctor --android-licenses   # accept all Android licenses
```

---

## 2. android/local.properties

This file is **git-ignored** (never commit it). Create it at `android/local.properties`:

```properties
flutter.sdk=C:\\src\\flutter
sdk.dir=C:\\Users\\Admin\\AppData\\Local\\Android\\Sdk
```

A template is provided at `android/local.properties.template`.

---

## 3. Firebase Phone OTP Setup

### 3a. Create / open your Firebase project
1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Select or create a project
3. **Authentication → Sign-in method → Phone → Enable**

### 3b. Register the Android app
1. Firebase Console → Project Overview → **Add app → Android**
2. Android package name: **`com.example.courierbook`**
3. Download **`google-services.json`** and place it at:
   ```
   android/app/google-services.json
   ```
   (This file is git-ignored — do NOT commit it.)

### 3c. Add SHA-1 and SHA-256 fingerprints (required for Phone Auth)

```powershell
# Debug keystore fingerprints:
keytool -list -v `
  -keystore "$env:USERPROFILE\.android\debug.keystore" `
  -alias androiddebugkey `
  -storepass android `
  -keypass android
```

Copy both **SHA-1** and **SHA-256** values.  
Add them in: **Firebase Console → Project Settings → Your app → SHA certificate fingerprints → Add fingerprint**

For a release build, repeat with your release keystore.

### 3d. Verify google-services.json placement
```
android/
  app/
    google-services.json   ← HERE
    build.gradle.kts
```

---

## 4. Supabase (optional — for cloud sync)

Pass these values at build/run time using `--dart-define`:

```powershell
flutter run `
  --dart-define=SUPABASE_URL=https://your-project.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

If the values are omitted, the app runs fully offline (SQLite only). Remote sync is skipped automatically.

---

## 5. Build commands

```powershell
# Get dependencies
flutter pub get

# Static analysis (0 errors expected)
flutter analyze

# Debug APK
flutter build apk --debug

# Release APK (per-ABI, obfuscated)
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols

# Release AAB (Play Store)
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
```

Output locations:
- APK: `build/app/outputs/flutter-apk/app-release*.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

---

## 6. GitHub Actions CI/CD

The workflow at `.github/workflows/build-release.yml` triggers on every push to `main` that touches `lib/`, `pubspec.yaml`, or `android/`.

### Required GitHub Secret

| Secret name | Value |
|-------------|-------|
| `GOOGLE_SERVICES_JSON` | Paste the **full contents** of your `google-services.json` |

Set it at: **GitHub → Repository → Settings → Secrets and variables → Actions → New repository secret**

If the secret is absent, the CI build uses a stub `google-services.json` — the APK will compile but Firebase Phone Auth will fail at runtime.

---

## 7. Project structure

```
lib/
├── core/           — barrel export (app_export.dart)
├── data/models/    — BookingModel, CustomerModel
├── presentation/
│   ├── bookings_list_screen/
│   ├── booking_form_screen/
│   └── sign_up_login_screen/   — Firebase Phone OTP
├── routes/
├── services/
│   ├── auth_service.dart          — Firebase Phone Auth wrapper
│   ├── persistent_auth_service.dart — SharedPreferences session
│   ├── database_service.dart      — SQLite (sqflite)
│   ├── supabase_service.dart      — Cloud sync (optional)
│   ├── sync_service.dart          — Online sync coordinator
│   └── google_sheets_service.dart — Sheets webhook (optional)
├── theme/
└── widgets/
```

---

## 8. Remaining manual steps (cannot be automated)

| Step | Action |
|------|--------|
| `google-services.json` | Download from Firebase Console and place at `android/app/` |
| SHA fingerprints | Add debug + release SHA-1/SHA-256 in Firebase Console |
| `GOOGLE_SERVICES_JSON` secret | Add to GitHub repo secrets for CI builds |
| `android/local.properties` | Create from `local.properties.template` |
| Release keystore | Generate and configure for production signing |
