class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'TezCredit';
  static const String appVersion = '1.0.0';

  // Asset Paths
  static const String loanPolicyAssetPath = 'assets/data/loan_policy.json';

  // Routes
  static const String biometricAuthRoute = '/';
  static const String homeRoute = '/home';
  static const String applicantRoute = '/applicant';
  static const String selfieRoute = '/selfie';
  static const String resultRoute = '/result';
  static const String emiCalculatorRoute = '/emi-calculator';

  // Home Screen
  static const double maxEligibleLoanDisplay = 1000000;

  // Security
  static const int maxBiometricAttempts = 3;
  static const int lockoutDurationSeconds = 30;
  static const int sessionTimeoutMinutes = 5;
  static const int encryptionKeyLength = 32;

  // Loan Policy Defaults
  static const double minIncome = 25000;
  static const double maxLoanAmount = 500000;
  static const int defaultTenureMonths = 36;
  static const double maxEmiToIncomeRatio = 0.4;

  // Secure Storage Keys
  static const String encryptionKeyStorageKey = 'encryption_key';
  static const String sessionTokenKey = 'session_token';
  static const String biometricVerifiedKey = 'biometric_verified';
  static const String deviceFingerprintKey = 'device_fingerprint';

  // Platform Channel
  static const String screenshotPreventionChannel =
      'com.tezcredit/screenshot_prevention';

  // Android Root Indicator Paths
  static const List<String> androidRootPaths = [
    '/system/app/Superuser.apk',
    '/sbin/su',
    '/system/bin/su',
    '/system/xbin/su',
    '/data/local/xbin/su',
    '/data/local/bin/su',
    '/system/sd/xbin/su',
    '/system/bin/failsafe/su',
    '/data/local/su',
  ];

  // iOS Jailbreak Indicator Paths
  static const List<String> iosJailbreakPaths = [
    '/Applications/Cydia.app',
    '/Library/MobileSubstrate/MobileSubstrate.dylib',
    '/bin/bash',
    '/usr/sbin/sshd',
    '/etc/apt',
    '/private/var/lib/apt/',
  ];

  // SSL Pinning (placeholder fingerprint for production)
  static const String pinnedCertificateFingerprint =
      'SHA256_FINGERPRINT_PLACEHOLDER';

  // Validation Patterns
  static const String panPattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
  static const String namePattern = r'^[a-zA-Z ]+$';
  static const String numericPattern = r'^[0-9]+$';
  static const String decimalPattern = r'^[0-9]*\.?[0-9]*$';

  // Employment Types
  static const List<String> employmentTypes = [
    'Salaried',
    'Self-Employed',
    'Business',
  ];
}
