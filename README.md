# TezCredit - Loan Onboarding App

A Flutter loan onboarding application built with Clean Architecture, featuring comprehensive security measures and an EMI calculator.

## Architecture

Clean Architecture with three layers:

- **Presentation** - Screens, Widgets, BLoCs (Flutter Bloc)
- **Domain** - Abstract repositories, Use cases
- **Data** - Models (Freezed), Data sources, Repository implementations

## Tech Stack

| Category | Package |
|---|---|
| State Management | flutter_bloc, equatable |
| Networking | dio |
| Navigation | go_router |
| DI | get_it |
| Models | freezed, json_serializable |
| Error Handling | dartz (Either) |
| Camera | camera |
| Storage | shared_preferences, flutter_secure_storage |
| Security | local_auth, encrypt, device_info_plus, screenshot |
| Hashing | crypto |

## Security Features

1. **Biometric Authentication** - Fingerprint/Face ID with device PIN fallback, 3-attempt lockout for 30 seconds
2. **Root/Jailbreak Detection** - Pure dart:io file path checks (no third-party package)
3. **Screenshot Prevention** - Android: FLAG_SECURE via platform channel; iOS: blur overlay on inactive
4. **Data Encryption** - AES-256 CBC with random IV per encryption (encrypt package)
5. **Secure Storage** - Encryption keys and tokens in flutter_secure_storage
6. **Session Management** - 5-minute inactivity timeout with automatic redirect
7. **Input Sanitization** - HTML/script stripping, pattern enforcement on all fields
8. **Certificate Pinning** - Dio native HttpClient with badCertificateCallback (no plugin)
9. **Device Fingerprinting** - SHA-256 hash of device attributes, verified on each launch
10. **Obfuscation Ready** - Build commands documented below

## Screens

| Route | Screen | Description |
|---|---|---|
| `/` | BiometricAuthScreen | Biometric authentication gate |
| `/applicant` | ApplicantDetailsScreen | Applicant form with validation |
| `/selfie` | SelfieCaptureScreen | Front camera selfie capture |
| `/result` | EligibilityResultScreen | Loan approval/rejection result |
| `/emi-calculator` | EmiCalculatorScreen | Live EMI calculator |

## Eligibility Rules

1. Monthly income >= 25,000
2. Credit history required (yes)
3. Requested loan amount <= 500,000
4. EMI (amount / tenure) <= 40% of monthly income

## Setup

```bash
# Install dependencies
flutter pub get

# Run code generation (required for freezed models)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Obfuscation (Production Builds)

```bash
# Android
flutter build apk --obfuscate --split-debug-info=build/debug-info

# iOS
flutter build ipa --obfuscate --split-debug-info=build/debug-info
```

## Project Structure

```
lib/
├── core/
│   ├── constants/         # App-wide constants
│   ├── error/             # Failure classes
│   ├── utils/             # Validators, EMI calculator
│   ├── security/          # All security services
│   └── di/                # GetIt dependency injection
├── data/
│   ├── models/            # Freezed models (domain objects)
│   ├── datasources/       # Local data sources
│   └── repositories/      # Repository implementations
├── domain/
│   ├── repositories/      # Abstract repository interfaces
│   └── usecases/          # Business logic use cases
├── presentation/
│   ├── bloc/              # BLoCs for each feature
│   ├── screens/           # App screens
│   └── widgets/           # Reusable widgets
└── main.dart              # Entry point, router, theme
```

## Notes

- Models use freezed — no separate entity classes
- All business logic lives in use cases only
- BLoCs call use cases only, never repositories directly
- Screens interact with BLoCs only, never use cases directly
- SSL pinning uses Dio's native HttpClient adapter (no plugin)
- Root detection uses dart:io File checks only (no package)
