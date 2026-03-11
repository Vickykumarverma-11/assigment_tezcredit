import 'package:assigment_tezcredit/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sanitizeInput', () {
    test('removes HTML tags', () {
      expect(Validators.sanitizeInput('<script>alert("xss")</script>'), 'alert(xss)');
    });

    test('removes javascript: pattern', () {
      expect(Validators.sanitizeInput('javascript:void(0)'), 'void(0)');
    });

    test('removes dangerous special characters', () {
      expect(Validators.sanitizeInput('hello<>&world'), 'helloworld');
    });

    test('trims whitespace', () {
      expect(Validators.sanitizeInput('  hello  '), 'hello');
    });

    test('returns clean input unchanged', () {
      expect(Validators.sanitizeInput('John Doe'), 'John Doe');
    });
  });

  group('sanitizePan', () {
    test('converts to uppercase and keeps alphanumeric', () {
      expect(Validators.sanitizePan('abcde1234f'), 'ABCDE1234F');
    });

    test('removes special characters', () {
      expect(Validators.sanitizePan('ABC-DE12@34F'), 'ABCDE1234F');
    });

    test('handles empty string', () {
      expect(Validators.sanitizePan(''), '');
    });
  });

  group('sanitizeNumeric', () {
    test('keeps digits', () {
      expect(Validators.sanitizeNumeric('12345'), '12345');
    });

    test('allows single decimal point', () {
      expect(Validators.sanitizeNumeric('123.45'), '123.45');
    });

    test('removes extra decimal points', () {
      expect(Validators.sanitizeNumeric('12.34.56'), '12.3456');
    });

    test('strips non-numeric characters', () {
      expect(Validators.sanitizeNumeric('12abc34'), '1234');
    });
  });

  group('sanitizeName', () {
    test('keeps letters and spaces', () {
      expect(Validators.sanitizeName('John Doe'), 'John Doe');
    });

    test('removes digits and special chars', () {
      expect(Validators.sanitizeName('John123!@#'), 'John');
    });
  });

  group('validateName', () {
    test('returns error for null', () {
      expect(Validators.validateName(null), 'Full name is required');
    });

    test('returns error for empty string', () {
      expect(Validators.validateName(''), 'Full name is required');
    });

    test('returns error for single character', () {
      expect(Validators.validateName('A'), 'Name must be at least 2 characters');
    });

    test('returns null for valid name', () {
      expect(Validators.validateName('John Doe'), isNull);
    });

    test('returns null for name with digits (sanitized)', () {
      // sanitizeName strips digits, leaving 'John' which is valid
      expect(Validators.validateName('John123'), isNull);
    });

    test('returns error for digits only name', () {
      // sanitizeName strips all digits, leaving empty string which fails regex
      expect(
        Validators.validateName('12345'),
        'Name must contain only letters and spaces',
      );
    });
  });

  group('validatePan', () {
    test('returns error for null', () {
      expect(Validators.validatePan(null), 'PAN number is required');
    });

    test('returns error for empty string', () {
      expect(Validators.validatePan(''), 'PAN number is required');
    });

    test('returns null for valid PAN', () {
      expect(Validators.validatePan('ABCDE1234F'), isNull);
    });

    test('returns error for invalid PAN format', () {
      expect(
        Validators.validatePan('12345'),
        'Invalid PAN format (e.g., ABCDE1234F)',
      );
    });

    test('accepts lowercase PAN (sanitized to uppercase)', () {
      expect(Validators.validatePan('abcde1234f'), isNull);
    });
  });

  group('validateIncome', () {
    test('returns error for null', () {
      expect(Validators.validateIncome(null), 'Monthly income is required');
    });

    test('returns error for empty', () {
      expect(Validators.validateIncome(''), 'Monthly income is required');
    });

    test('returns error for zero', () {
      expect(Validators.validateIncome('0'), 'Income must be greater than zero');
    });

    test('returns error for non-numeric', () {
      expect(Validators.validateIncome('abc'), 'Income must contain only digits');
    });

    test('returns null for valid income', () {
      expect(Validators.validateIncome('50000'), isNull);
    });
  });

  group('validateLoanAmount', () {
    test('returns error for null', () {
      expect(Validators.validateLoanAmount(null), 'Loan amount is required');
    });

    test('returns error for zero', () {
      expect(
        Validators.validateLoanAmount('0'),
        'Loan amount must be greater than zero',
      );
    });

    test('returns null for valid amount', () {
      expect(Validators.validateLoanAmount('100000'), isNull);
    });
  });

  group('validateDecimalInput', () {
    test('returns error for null', () {
      expect(
        Validators.validateDecimalInput(null, 'Rate'),
        'Rate is required',
      );
    });

    test('returns error for zero', () {
      expect(
        Validators.validateDecimalInput('0', 'Rate'),
        'Rate must be greater than zero',
      );
    });

    test('returns null for valid decimal', () {
      expect(Validators.validateDecimalInput('12.5', 'Rate'), isNull);
    });
  });

  group('validateTenure', () {
    test('returns error for null', () {
      expect(Validators.validateTenure(null), 'Tenure is required');
    });

    test('returns error for zero', () {
      expect(
        Validators.validateTenure('0'),
        'Tenure must be greater than zero',
      );
    });

    test('returns error for non-numeric', () {
      expect(Validators.validateTenure('abc'), 'Tenure must contain only digits');
    });

    test('returns null for valid tenure', () {
      expect(Validators.validateTenure('12'), isNull);
    });
  });
}
