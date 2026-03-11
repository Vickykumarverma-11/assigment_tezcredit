import 'package:assigment_tezcredit/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter.formatIndian', () {
    test('formats small numbers without commas', () {
      expect(CurrencyFormatter.formatIndian(500), '\u20B9500');
    });

    test('formats thousands with comma', () {
      expect(CurrencyFormatter.formatIndian(5000), '\u20B95,000');
    });

    test('formats lakhs with Indian grouping', () {
      expect(CurrencyFormatter.formatIndian(500000), '\u20B95,00,000');
    });

    test('formats ten lakhs', () {
      expect(CurrencyFormatter.formatIndian(1000000), '\u20B910,00,000');
    });

    test('formats crores', () {
      expect(CurrencyFormatter.formatIndian(50000000), '\u20B95,00,00,000');
    });

    test('formats zero', () {
      expect(CurrencyFormatter.formatIndian(0), '\u20B90');
    });

    test('rounds decimals', () {
      expect(CurrencyFormatter.formatIndian(8884.88), '\u20B98,885');
    });
  });

  group('CurrencyFormatter.formatShort', () {
    test('formats lakhs', () {
      expect(CurrencyFormatter.formatShort(500000), '5.00 L');
    });

    test('formats crores', () {
      expect(CurrencyFormatter.formatShort(10000000), '1.00 Cr');
    });

    test('formats thousands', () {
      expect(CurrencyFormatter.formatShort(50000), '50.0 K');
    });

    test('formats small numbers', () {
      expect(CurrencyFormatter.formatShort(999), '999');
    });
  });
}
