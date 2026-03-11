import 'package:dartz/dartz.dart';

import 'package:assigment_tezcredit/core/error/failures.dart';
import 'package:assigment_tezcredit/data/datasources/loan_policy_local_datasource.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/data/models/eligibility_result_model.dart';
import 'package:assigment_tezcredit/data/models/loan_policy_model.dart';
import 'package:assigment_tezcredit/domain/repositories/loan_repository.dart';

class LoanRepositoryImpl implements LoanRepository {
  final LoanPolicyLocalDatasource _localDatasource;

  LoanRepositoryImpl({required LoanPolicyLocalDatasource localDatasource})
      : _localDatasource = localDatasource;

  @override
  Future<Either<Failure, List<LoanPolicyModel>>> loadLoanPolicies() async {
    try {
      final policies = await _localDatasource.loadLoanPolicies();
      return Right(policies);
    } catch (e) {
      return Left(LocalDataFailure('Failed to load loan policies: $e'));
    }
  }

  @override
  Future<Either<Failure, EligibilityResultModel>> evaluateEligibility(
    ApplicantModel applicant,
    LoanPolicyModel policy,
  ) async {
    try {
      final rejectionReasons = <String>[];

      // Rule 1: monthly_income >= min_income
      if (applicant.monthlyIncome < policy.minIncome) {
        rejectionReasons.add(
          'Monthly income must be at least ₹${policy.minIncome.toStringAsFixed(0)}',
        );
      }

      // Rule 2: credit_history == credit_history_required
      if (applicant.creditHistory != policy.creditHistoryRequired) {
        rejectionReasons.add('Credit history is required');
      }

      // Rule 3: requested_loan_amount <= max_loan_amount
      if (applicant.requestedLoanAmount > policy.maxLoanAmount) {
        rejectionReasons.add(
          'Loan amount exceeds maximum of ₹${policy.maxLoanAmount.toStringAsFixed(0)}',
        );
      }

      // Rule 4: EMI <= monthly_income * 0.4
      final emi = applicant.requestedLoanAmount / policy.tenureMonths;
      final maxAllowableEmi = applicant.monthlyIncome * 0.4;

      if (emi > maxAllowableEmi) {
        rejectionReasons.add(
          'EMI ₹${emi.toStringAsFixed(2)} exceeds 40% of monthly income '
          '(₹${maxAllowableEmi.toStringAsFixed(2)})',
        );
      }

      final isApproved = rejectionReasons.isEmpty;
      final eligibleAmount = isApproved
          ? applicant.requestedLoanAmount
          : _calculateMaxEligibleAmount(applicant.monthlyIncome, policy);

      return Right(
        EligibilityResultModel(
          isApproved: isApproved,
          eligibleAmount: eligibleAmount,
          estimatedEmi: isApproved ? emi : 0.0,
          rejectionReasons: rejectionReasons,
        ),
      );
    } catch (e) {
      return Left(ValidationFailure('Eligibility evaluation failed: $e'));
    }
  }

  double _calculateMaxEligibleAmount(
    double monthlyIncome,
    LoanPolicyModel policy,
  ) {
    final maxEmi = monthlyIncome * 0.4;
    final maxFromEmi = maxEmi * policy.tenureMonths;
    return maxFromEmi < policy.maxLoanAmount ? maxFromEmi : policy.maxLoanAmount;
  }
}
