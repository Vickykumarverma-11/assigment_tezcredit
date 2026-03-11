import 'dart:math';

class EmiCalculator {
  EmiCalculator._();

  /// Calculates EMI using the standard formula:
  /// EMI = P * r * (1+r)^n / ((1+r)^n - 1)
  /// where:
  ///   P = principal (loan amount)
  ///   r = monthly interest rate (annual_rate / 12 / 100)
  ///   n = tenure in months
  ///
  /// Returns a record of (monthlyEmi, totalPayment, totalInterest).
  static ({double monthlyEmi, double totalPayment, double totalInterest})
      calculate({
    required double loanAmount,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    if (loanAmount <= 0 || annualInterestRate <= 0 || tenureMonths <= 0) {
      return (monthlyEmi: 0.0, totalPayment: 0.0, totalInterest: 0.0);
    }

    final double monthlyRate = annualInterestRate / 12 / 100;
    final int n = tenureMonths;
    final double onePlusRPowN = pow(1 + monthlyRate, n).toDouble();

    final double emi =
        (loanAmount * monthlyRate * onePlusRPowN) / (onePlusRPowN - 1);
    final double totalPayment = emi * n;
    final double totalInterest = totalPayment - loanAmount;

    return (
      monthlyEmi: double.parse(emi.toStringAsFixed(2)),
      totalPayment: double.parse(totalPayment.toStringAsFixed(2)),
      totalInterest: double.parse(totalInterest.toStringAsFixed(2)),
    );
  }
}
