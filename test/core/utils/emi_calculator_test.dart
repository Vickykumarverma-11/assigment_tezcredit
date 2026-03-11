import 'package:assigment_tezcredit/core/utils/emi_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmiCalculator.calculate', () {
    test('calculates correct EMI for known values', () {
      // Loan: 1,00,000 at 12% for 12 months
      // Expected EMI ≈ 8884.88
      final result = EmiCalculator.calculate(
        loanAmount: 100000,
        annualInterestRate: 12,
        tenureMonths: 12,
      );

      expect(result.monthlyEmi, 8884.88);
      expect(result.totalPayment, 106618.55);
      expect(result.totalInterest, 6618.55);
    });

    test('calculates correct EMI for larger loan', () {
      // Loan: 5,00,000 at 10% for 36 months
      final result = EmiCalculator.calculate(
        loanAmount: 500000,
        annualInterestRate: 10,
        tenureMonths: 36,
      );

      expect(result.monthlyEmi, 16133.59);
      expect(result.totalPayment, 580809.37);
      expect(result.totalInterest, 80809.37);
    });

    test('returns zeros for zero loan amount', () {
      final result = EmiCalculator.calculate(
        loanAmount: 0,
        annualInterestRate: 12,
        tenureMonths: 12,
      );

      expect(result.monthlyEmi, 0.0);
      expect(result.totalPayment, 0.0);
      expect(result.totalInterest, 0.0);
    });

    test('returns zeros for zero interest rate', () {
      final result = EmiCalculator.calculate(
        loanAmount: 100000,
        annualInterestRate: 0,
        tenureMonths: 12,
      );

      expect(result.monthlyEmi, 0.0);
      expect(result.totalPayment, 0.0);
      expect(result.totalInterest, 0.0);
    });

    test('returns zeros for zero tenure', () {
      final result = EmiCalculator.calculate(
        loanAmount: 100000,
        annualInterestRate: 12,
        tenureMonths: 0,
      );

      expect(result.monthlyEmi, 0.0);
      expect(result.totalPayment, 0.0);
      expect(result.totalInterest, 0.0);
    });

    test('returns zeros for negative inputs', () {
      final result = EmiCalculator.calculate(
        loanAmount: -100000,
        annualInterestRate: 12,
        tenureMonths: 12,
      );

      expect(result.monthlyEmi, 0.0);
      expect(result.totalPayment, 0.0);
      expect(result.totalInterest, 0.0);
    });

    test('total interest is always positive for valid inputs', () {
      final result = EmiCalculator.calculate(
        loanAmount: 200000,
        annualInterestRate: 8.5,
        tenureMonths: 24,
      );

      expect(result.totalInterest, greaterThan(0));
      expect(result.totalPayment, greaterThan(result.monthlyEmi));
      expect(result.monthlyEmi, greaterThan(0));
    });

    test('total payment equals EMI times tenure', () {
      final result = EmiCalculator.calculate(
        loanAmount: 300000,
        annualInterestRate: 15,
        tenureMonths: 48,
      );

      expect(result.totalPayment, closeTo(result.monthlyEmi * 48, 1.0));
    });
  });
}
