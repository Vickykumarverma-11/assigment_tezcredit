import 'package:assigment_tezcredit/core/constants/app_constants.dart';

class Validators {
  Validators._();

  static final RegExp _panRegex = RegExp(AppConstants.panPattern);
  static final RegExp _nameRegex = RegExp(AppConstants.namePattern);
  static final RegExp _numericRegex = RegExp(AppConstants.numericPattern);
  static final RegExp _decimalRegex = RegExp(AppConstants.decimalPattern);
  static final RegExp _htmlTagRegex = RegExp(r'<[^>]*>');
  static final RegExp _scriptRegex =
      RegExp(r'(javascript:|on\w+=)', caseSensitive: false);
  static final RegExp _specialCharsRegex = RegExp('[<>&"\';\\\\/]');

  /// Strips HTML tags, script patterns, and dangerous special characters.
  static String sanitizeInput(String input) {
    String sanitized = input;
    sanitized = sanitized.replaceAll(_htmlTagRegex, '');
    sanitized = sanitized.replaceAll(_scriptRegex, '');
    sanitized = sanitized.replaceAll(_specialCharsRegex, '');
    return sanitized.trim();
  }

  /// Sanitizes and forces uppercase, allows only [A-Z0-9].
  static String sanitizePan(String input) {
    final upper = input.toUpperCase();
    final buffer = StringBuffer();
    for (final char in upper.runes) {
      final c = String.fromCharCode(char);
      if (RegExp(r'[A-Z0-9]').hasMatch(c)) {
        buffer.write(c);
      }
    }
    return buffer.toString();
  }

  /// Allows only digits and a single decimal point.
  static String sanitizeNumeric(String input) {
    final buffer = StringBuffer();
    bool hasDecimal = false;
    for (final char in input.runes) {
      final c = String.fromCharCode(char);
      if (RegExp(r'[0-9]').hasMatch(c)) {
        buffer.write(c);
      } else if (c == '.' && !hasDecimal) {
        buffer.write(c);
        hasDecimal = true;
      }
    }
    return buffer.toString();
  }

  /// Allows only letters and spaces.
  static String sanitizeName(String input) {
    final buffer = StringBuffer();
    for (final char in input.runes) {
      final c = String.fromCharCode(char);
      if (RegExp(r'[a-zA-Z ]').hasMatch(c)) {
        buffer.write(c);
      }
    }
    return buffer.toString();
  }

  /// Validates full name: non-empty, letters and spaces only.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    final sanitized = sanitizeName(value);
    if (!_nameRegex.hasMatch(sanitized)) {
      return 'Name must contain only letters and spaces';
    }
    if (sanitized.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates PAN: exactly [A-Z]{5}[0-9]{4}[A-Z]{1}.
  static String? validatePan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'PAN number is required';
    }
    final sanitized = sanitizePan(value);
    if (!_panRegex.hasMatch(sanitized)) {
      return 'Invalid PAN format (e.g., ABCDE1234F)';
    }
    return null;
  }

  /// Validates monthly income: non-empty, digits only, > 0.
  static String? validateIncome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Monthly income is required';
    }
    if (!_numericRegex.hasMatch(value.trim())) {
      return 'Income must contain only digits';
    }
    final income = double.tryParse(value.trim());
    if (income == null || income <= 0) {
      return 'Income must be greater than zero';
    }
    return null;
  }

  /// Validates loan amount: non-empty, digits only, > 0.
  static String? validateLoanAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Loan amount is required';
    }
    if (!_numericRegex.hasMatch(value.trim())) {
      return 'Loan amount must contain only digits';
    }
    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return 'Loan amount must be greater than zero';
    }
    return null;
  }

  /// Validates EMI calculator inputs.
  static String? validateDecimalInput(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (!_decimalRegex.hasMatch(value.trim())) {
      return '$fieldName must be a valid number';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return '$fieldName must be greater than zero';
    }
    return null;
  }

  /// Validates tenure: non-empty, digits only, > 0.
  static String? validateTenure(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tenure is required';
    }
    if (!_numericRegex.hasMatch(value.trim())) {
      return 'Tenure must contain only digits';
    }
    final tenure = int.tryParse(value.trim());
    if (tenure == null || tenure <= 0) {
      return 'Tenure must be greater than zero';
    }
    return null;
  }
}
