# TezCredit - Loan Onboarding App

A Flutter loan onboarding application built with Clean Architecture, featuring comprehensive security measures, multi-tier eligibility evaluation, and an EMI calculator.

## Architecture

Clean Architecture with three layers:

- **Presentation** - Screens, Widgets, BLoCs (Flutter Bloc), Mixins
- **Domain** - Abstract repositories, Use cases
- **Data** - Models (Freezed), Data sources, Repository implementations

## Tech Stack

| Category | Package |
|---|---|
| State Management | flutter_bloc, equatable |
| Networking | dio (with native SSL pinning) |
| Navigation | go_router (with session guard) |
| DI | get_it |
| Models | freezed, json_serializable |
| Error Handling | dartz (Either<Failure, T>) |
| Camera | camera |
| Storage | shared_preferences, flutter_secure_storage |
| Security | local_auth, encrypt, device_info_plus, crypto |
| Testing | bloc_test, mocktail |

## Security Features

1. **Biometric Authentication** - Fingerprint/Face ID with device PIN fallback, 3-attempt lockout for 30 seconds
2. **Root/Jailbreak Detection** - Pure dart:io file path checks (no third-party package)
3. **Screenshot Prevention** - Android: FLAG_SECURE via platform channel; iOS: blur overlay on inactive (via mixin)
4. **Data Encryption** - AES-256 CBC with random IV per encryption (encrypt package)
5. **Secure Storage** - Encryption keys and tokens in flutter_secure_storage
6. **Session Management** - 5-minute inactivity timeout with automatic redirect to biometric auth
7. **Input Sanitization** - HTML/script stripping, pattern enforcement on all fields
8. **Certificate Pinning** - Dio native HttpClient with SHA-256 fingerprint validation (no plugin)
9. **Device Fingerprinting** - SHA-256 hash of device attributes, verified on each launch
10. **Obfuscation Ready** - Build commands documented below

## Screens

| Route | Screen | Description |
|---|---|---|
| `/` | BiometricAuthScreen | Biometric authentication gate |
| `/home` | HomeScreen | Dashboard with carousel, loan eligibility card, quick actions |
| `/applicant` | ApplicantDetailsScreen | KYC form with validation and encryption |
| `/selfie` | SelfieCaptureScreen | Front camera selfie capture |
| `/result` | EligibilityResultScreen | Loan approval/rejection with detailed breakdown |
| `/emi-calculator` | EmiCalculatorScreen | Live EMI calculator with sliders |

## Loan Policy Tiers

| Min Income | Max Loan | Tenure |
|---|---|---|
| ₹25,000 | ₹2,00,000 | 24 months |
| ₹35,000 | ₹5,00,000 | 36 months |
| ₹50,000 | ₹10,00,000 | 48 months |
| ₹75,000 | ₹20,00,000 | 60 months |
| ₹1,00,000 | ₹50,00,000 | 84 months |

## Eligibility Rules

1. Monthly income >= policy tier minimum
2. Credit history required (verified)
3. Requested loan amount <= policy tier maximum
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

## Testing

```bash
# Run all unit tests
flutter test

# Run with coverage
flutter test --coverage
```

**Test Coverage:**
- `validators_test.dart` - Input sanitization & validation (25 tests)
- `emi_calculator_test.dart` - EMI formula accuracy & edge cases (8 tests)
- `loan_repository_impl_test.dart` - Eligibility rules & policy matching (9 tests)
- `emi_bloc_test.dart` - EMI bloc state transitions (7 tests)
- `eligibility_bloc_test.dart` - Eligibility bloc with mocked usecases (7 tests)

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
│   ├── error/             # Typed Failure classes (Equatable)
│   ├── utils/             # Validators, EMI calculator, currency formatter, BlocObserver
│   ├── security/          # Biometric, encryption, root detection, SSL pinning, session, device fingerprint
│   └── di/                # GetIt dependency injection
├── data/
│   ├── models/            # Freezed immutable models with JSON serialization
│   ├── datasources/       # Local data sources (asset JSON)
│   └── repositories/      # Repository implementations with Either<Failure, T>
├── domain/
│   ├── repositories/      # Abstract repository interfaces
│   └── usecases/          # Business logic use cases (callable classes)
├── presentation/
│   ├── bloc/              # BLoCs for each feature (Security, Applicant, Eligibility, Camera, EMI)
│   ├── screens/           # App screens (6 screens)
│   ├── widgets/           # Reusable widgets (BlurOverlay)
│   └── mixins/            # ScreenshotPreventionMixin
├── main.dart              # Entry point, GoRouter, theme
test/
├── core/utils/            # Validator & EMI calculator tests
├── data/repositories/     # Repository logic tests with mocks
└── presentation/bloc/     # BLoC state transition tests
```

## Design Decisions

- **Single model layer** - Freezed models serve as both domain entities and data transfer objects, avoiding unnecessary mapping boilerplate
- **BLoCs as factories** - Each screen gets a fresh BLoC instance for proper lifecycle management
- **ScreenshotPreventionMixin** - Extracts lifecycle subscription management to prevent memory leaks across 6 screens
- **CurrencyFormatter** - Centralized Indian number formatting (₹X,XX,XXX) used by all screens
- **BlocObserver** - Global logging of all state transitions for debugging
- **Session guard in GoRouter** - Redirect middleware checks session expiry on every navigation
- **SSL pinning uses crypto SHA-256** - Actual fingerprint hash comparison, not raw DER bytes
