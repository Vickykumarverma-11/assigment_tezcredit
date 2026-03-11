import 'package:assigment_tezcredit/core/error/failures.dart';
import 'package:assigment_tezcredit/data/datasources/loan_policy_local_datasource.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/data/models/loan_policy_model.dart';
import 'package:assigment_tezcredit/data/repositories/loan_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoanPolicyLocalDatasource extends Mock
    implements LoanPolicyLocalDatasource {}

void main() {
  late LoanRepositoryImpl repository;
  late MockLoanPolicyLocalDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockLoanPolicyLocalDatasource();
    repository = LoanRepositoryImpl(localDatasource: mockDatasource);
  });

  final tPolicy = LoanPolicyModel(
    minIncome: 25000,
    maxLoanAmount: 500000,
    tenureMonths: 36,
    creditHistoryRequired: 1,
  );

  final tPolicies = [tPolicy];

  group('loadLoanPolicies', () {
    test('returns list of policies on success', () async {
      when(() => mockDatasource.loadLoanPolicies())
          .thenAnswer((_) async => tPolicies);

      final result = await repository.loadLoanPolicies();

      expect(result, Right(tPolicies));
      verify(() => mockDatasource.loadLoanPolicies()).called(1);
    });

    test('returns LocalDataFailure on exception', () async {
      when(() => mockDatasource.loadLoanPolicies())
          .thenThrow(Exception('load error'));

      final result = await repository.loadLoanPolicies();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDataFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });

  group('evaluateEligibility', () {
    ApplicantModel makeApplicant({
      double monthlyIncome = 50000,
      double requestedLoanAmount = 200000,
      int creditHistory = 1,
    }) {
      return ApplicantModel(
        fullName: 'Test User',
        panNumber: 'ABCDE1234F',
        monthlyIncome: monthlyIncome,
        requestedLoanAmount: requestedLoanAmount,
        employmentType: 'Salaried',
        creditHistory: creditHistory,
        selfiePath: '/path/to/selfie.jpg',
      );
    }

    test('approves applicant meeting all criteria', () async {
      final applicant = makeApplicant(
        monthlyIncome: 50000,
        requestedLoanAmount: 200000,
        creditHistory: 1,
      );

      final result = await repository.evaluateEligibility(applicant, tPolicy);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be Right'),
        (eligibility) {
          expect(eligibility.isApproved, true);
          expect(eligibility.rejectionReasons, isEmpty);
          expect(eligibility.eligibleAmount, 200000);
          expect(eligibility.estimatedEmi, greaterThan(0));
          expect(eligibility.tenureMonths, 36);
        },
      );
    });

    test('rejects when monthly income below minimum', () async {
      final applicant = makeApplicant(monthlyIncome: 10000);

      final result = await repository.evaluateEligibility(applicant, tPolicy);

      result.fold(
        (_) => fail('should be Right'),
        (eligibility) {
          expect(eligibility.isApproved, false);
          expect(
            eligibility.rejectionReasons,
            contains('Monthly income must be at least ₹25000'),
          );
        },
      );
    });

    test('rejects when credit history does not match', () async {
      final applicant = makeApplicant(creditHistory: 0);

      final result = await repository.evaluateEligibility(applicant, tPolicy);

      result.fold(
        (_) => fail('should be Right'),
        (eligibility) {
          expect(eligibility.isApproved, false);
          expect(
            eligibility.rejectionReasons,
            contains('Credit history is required'),
          );
        },
      );
    });

    test('rejects when loan amount exceeds maximum', () async {
      final applicant = makeApplicant(requestedLoanAmount: 600000);

      final result = await repository.evaluateEligibility(applicant, tPolicy);

      result.fold(
        (_) => fail('should be Right'),
        (eligibility) {
          expect(eligibility.isApproved, false);
          expect(
            eligibility.rejectionReasons,
            contains('Loan amount exceeds maximum of ₹500000'),
          );
        },
      );
    });

    test('rejects when EMI exceeds 40% of monthly income', () async {
      // Income: 25000 -> max EMI = 10000
      // Loan: 500000 / 36 months = 13888.89 EMI -> exceeds limit
      final applicant = makeApplicant(
        monthlyIncome: 25000,
        requestedLoanAmount: 500000,
      );

      final result = await repository.evaluateEligibility(applicant, tPolicy);

      result.fold(
        (_) => fail('should be Right'),
        (eligibility) {
          expect(eligibility.isApproved, false);
          expect(
            eligibility.rejectionReasons.any((r) => r.contains('EMI')),
            true,
          );
        },
      );
    });

    test('collects multiple rejection reasons', () async {
      final applicant = makeApplicant(
        monthlyIncome: 10000,
        requestedLoanAmount: 600000,
        creditHistory: 0,
      );

      final result = await repository.evaluateEligibility(applicant, tPolicy);

      result.fold(
        (_) => fail('should be Right'),
        (eligibility) {
          expect(eligibility.isApproved, false);
          expect(eligibility.rejectionReasons.length, greaterThanOrEqualTo(3));
        },
      );
    });

    test('calculates max eligible amount when rejected', () async {
      final applicant = makeApplicant(
        monthlyIncome: 25000,
        requestedLoanAmount: 600000,
      );

      final result = await repository.evaluateEligibility(applicant, tPolicy);

      result.fold(
        (_) => fail('should be Right'),
        (eligibility) {
          expect(eligibility.isApproved, false);
          // max EMI = 25000 * 0.4 = 10000
          // max from EMI = 10000 * 36 = 360000
          // min(360000, 500000) = 360000
          expect(eligibility.eligibleAmount, 360000);
        },
      );
    });
  });
}
