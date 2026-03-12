# TezCredit

Loan onboarding app built with Flutter. Handles the full flow — biometric login, KYC form, selfie capture, loan eligibility check, and an EMI calculator. Uses clean architecture throughout.

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

The `build_runner` step is needed because models use `freezed` for code generation. Skip it if the `.freezed.dart` and `.g.dart` files are already there.

## Build

```bash
# debug
flutter run

# release apk
flutter build apk --release

# release with obfuscation (recommended for prod)
flutter build apk --obfuscate --split-debug-info=build/debug-info

# ios
flutter build ipa --obfuscate --split-debug-info=build/debug-info
```

## How It Works

The app follows a step-by-step loan onboarding flow:

**Biometric Auth (`/`)** → User authenticates via fingerprint/faceID/PIN. Device gets checked for root/jailbreak. After 5 failed attempts, locks out for 30 seconds.

**Home (`/home`)** → Dashboard with a scrolling carousel, eligibility card, and shortcut to EMI calculator.

**Applicant Form (`/applicant`)** → User fills in name, PAN, monthly income, loan amount, employment type, and credit history. All sensitive fields (PAN, income, loan amount) are AES-256 encrypted before being passed forward. Inputs are sanitized to prevent injection.

**Selfie Capture (`/selfie`)** → Opens front camera, user takes a selfie inside a circular frame. Can review and retake before confirming.

**Eligibility Result (`/result`)** → Loads loan policies from a local JSON file, matches the applicant's income to the right policy tier, and runs eligibility rules. Shows approved (with loan details) or rejected (with reasons).

**EMI Calculator (`/emi-calculator`)** → Standalone tool with sliders for amount, interest rate, and tenure. Shows monthly EMI, total payment, and total interest in real time.

## Eligibility Rules

The evaluation logic lives in `lib/data/repositories/loan_repository_impl.dart`. Four rules must all pass for approval:

1. **Income check** — `monthly_income >= min_income` (minimum ₹25,000 depending on tier)
2. **Credit history** — `credit_history == 1` (must have satisfactory credit)
3. **Loan cap** — `requested_amount <= max_loan_amount` (varies by tier, up to ₹50L)
4. **EMI affordability** — `emi <= monthly_income * 0.4` where `emi = requested_amount / tenure_months`

If any rule fails, the applicant is rejected with specific reasons. On rejection, the app also calculates the max eligible amount they could qualify for.

### Loan Policy Tiers

Loaded from `assets/data/loan_policy.json`:

| Min Income | Max Loan | Tenure |
|------------|----------|--------|
| ₹25,000 | ₹2,00,000 | 24 mo |
| ₹35,000 | ₹5,00,000 | 36 mo |
| ₹50,000 | ₹10,00,000 | 48 mo |
| ₹75,000 | ₹20,00,000 | 60 mo |
| ₹1,00,000 | ₹50,00,000 | 84 mo |

## Architecture

```
lib/
├── core/
│   ├── constants/         # routes, validation patterns, policy defaults
│   ├── di/                # GetIt service locator setup
│   ├── error/             # Failure types (extends Equatable)
│   ├── security/          # biometric, encryption, root detection, ssl pinning,
│   │                        session management, screenshot prevention, device fingerprint
│   └── utils/             # validators, emi calculator, currency formatter
├── data/
│   ├── models/            # freezed models (ApplicantModel, LoanPolicyModel, EligibilityResultModel)
│   ├── datasources/       # reads loan_policy.json from assets
│   └── repositories/      # eligibility evaluation logic
├── domain/
│   ├── repositories/      # abstract interfaces
│   └── usecases/          # LoadLoanPolicy, EvaluateEligibility
├── presentation/
│   ├── bloc/              # SecurityBloc, ApplicantBloc, EligibilityBloc, CameraBloc, EmiBloc
│   ├── screens/           # 6 screens (biometric, home, applicant, selfie, result, emi)
│   ├── widgets/           # BlurOverlay (used for screenshot prevention)
│   └── mixins/            # ScreenshotPreventionMixin
└── main.dart              # app entry, GoRouter config, theme
```

**State management** — `flutter_bloc`. Each bloc is registered as a factory in GetIt so screens get fresh instances.

**Navigation** — `go_router` with a redirect guard that checks session expiry on every route change. Expired session sends user back to biometric auth.

**Error handling** — uses `dartz` Either type. Repository methods return `Either<Failure, T>` so errors are handled explicitly without try-catch at the UI level.

**Models** — `freezed` for immutability + `json_serializable` for JSON parsing. Single model layer (no separate entity classes) to keep things simple.

## Security

This is a fintech app, so security is layered:

- **Biometric auth** — `local_auth` package, supports fingerprint/faceID with device PIN fallback
- **Root/jailbreak detection** — checks known file paths on Android and iOS using `dart:io` (no third-party dependency)
- **Device fingerprinting** — SHA-256 hash of device attributes (model, brand, OS version), verified on each launch
- **Encryption** — AES-256 CBC with random IV for sensitive data. Key generated on first launch, stored in `flutter_secure_storage`
- **Session timeout** — 5-minute inactivity timeout, configurable in `AppConstants`
- **Screenshot prevention** — Android uses `FLAG_SECURE` via platform channel. iOS uses a blur overlay when app goes to background
- **SSL pinning** — custom `HttpClient` on Dio that validates server certificate SHA-256 fingerprint
- **Input sanitization** — strips HTML tags, script patterns, and dangerous characters from all user inputs

## Tests

```bash
flutter test
```

Tests cover:
- **Validators** — input sanitization, PAN format, name/income/loan validation
- **EMI Calculator** — formula accuracy, edge cases (zero rate, large amounts)
- **LoanRepositoryImpl** — all 4 eligibility rules, rejection reasons, max eligible calculation
- **EmiBloc** — state transitions on input changes
- **EligibilityBloc** — full flow with mocked usecases, approval and rejection paths

## Dependencies

| What | Package |
|------|---------|
| State management | `flutter_bloc`, `equatable` |
| Routing | `go_router` |
| DI | `get_it` |
| Networking | `dio` |
| Models | `freezed`, `json_serializable` |
| Error handling | `dartz` |
| Camera | `camera` |
| Storage | `shared_preferences`, `flutter_secure_storage` |
| Auth | `local_auth` |
| Encryption | `encrypt`, `crypto` |
| Device info | `device_info_plus` |
| Testing | `bloc_test`, `mocktail` |

## Notes

- The SSL pinning fingerprint in `AppConstants` is a placeholder (`SHA256_FINGERPRINT_PLACEHOLDER`). Replace it with the actual server cert fingerprint before going to production.
- There's a debug skip button on the biometric screen for testing — remove it before release.
- The app is locked to portrait orientation.
- Currency formatting follows Indian numbering (₹X,XX,XXX).
