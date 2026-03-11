import 'package:assigment_tezcredit/core/error/failures.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/data/models/eligibility_result_model.dart';
import 'package:assigment_tezcredit/data/models/loan_policy_model.dart';
import 'package:assigment_tezcredit/domain/usecases/evaluate_eligibility_usecase.dart';
import 'package:assigment_tezcredit/domain/usecases/load_loan_policy_usecase.dart';
import 'package:assigment_tezcredit/presentation/bloc/eligibility_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadLoanPolicyUsecase extends Mock implements LoadLoanPolicyUsecase {}

class MockEvaluateEligibilityUsecase extends Mock
    implements EvaluateEligibilityUsecase {}

class FakeApplicantModel extends Fake implements ApplicantModel {}

class FakeLoanPolicyModel extends Fake implements LoanPolicyModel {}

void main() {
  late MockLoadLoanPolicyUsecase mockLoadPolicies;
  late MockEvaluateEligibilityUsecase mockEvaluate;

  final tApplicant = ApplicantModel(
    fullName: 'Test User',
    panNumber: 'ABCDE1234F',
    monthlyIncome: 50000,
    requestedLoanAmount: 200000,
    employmentType: 'Salaried',
    creditHistory: 1,
    selfiePath: '/path/selfie.jpg',
  );

  final tPolicies = [
    LoanPolicyModel(
      minIncome: 25000,
      maxLoanAmount: 200000,
      tenureMonths: 24,
      creditHistoryRequired: 1,
    ),
    LoanPolicyModel(
      minIncome: 35000,
      maxLoanAmount: 500000,
      tenureMonths: 36,
      creditHistoryRequired: 1,
    ),
    LoanPolicyModel(
      minIncome: 50000,
      maxLoanAmount: 1000000,
      tenureMonths: 48,
      creditHistoryRequired: 1,
    ),
  ];

  final tResult = EligibilityResultModel(
    isApproved: true,
    eligibleAmount: 200000,
    estimatedEmi: 5555.56,
    tenureMonths: 48,
    rejectionReasons: [],
  );

  setUpAll(() {
    registerFallbackValue(FakeApplicantModel());
    registerFallbackValue(FakeLoanPolicyModel());
  });

  setUp(() {
    mockLoadPolicies = MockLoadLoanPolicyUsecase();
    mockEvaluate = MockEvaluateEligibilityUsecase();
  });

  EligibilityBloc buildBloc() => EligibilityBloc(
        evaluateEligibilityUsecase: mockEvaluate,
        loadLoanPolicyUsecase: mockLoadPolicies,
      );

  test('initial state is EligibilityInitial', () {
    expect(buildBloc().state, const EligibilityInitial());
  });

  group('EvaluateEligibility', () {
    blocTest<EligibilityBloc, EligibilityState>(
      'emits [Loading, Success] when policies load and evaluation succeeds',
      build: () {
        when(() => mockLoadPolicies()).thenAnswer(
          (_) async => Right(tPolicies),
        );
        when(() => mockEvaluate(
              applicant: any(named: 'applicant'),
              policy: any(named: 'policy'),
            )).thenAnswer((_) async => Right(tResult));
        return buildBloc();
      },
      act: (bloc) => bloc.add(EvaluateEligibility(applicant: tApplicant)),
      expect: () => [
        const EligibilityLoading(),
        EligibilitySuccess(result: tResult),
      ],
    );

    blocTest<EligibilityBloc, EligibilityState>(
      'selects highest matching policy tier for applicant income',
      build: () {
        when(() => mockLoadPolicies()).thenAnswer(
          (_) async => Right(tPolicies),
        );
        when(() => mockEvaluate(
              applicant: any(named: 'applicant'),
              policy: any(named: 'policy'),
            )).thenAnswer((_) async => Right(tResult));
        return buildBloc();
      },
      act: (bloc) => bloc.add(EvaluateEligibility(applicant: tApplicant)),
      verify: (_) {
        // Applicant income 50000 matches all 3 tiers; should pick last (50000 tier)
        final captured = verify(() => mockEvaluate(
              applicant: captureAny(named: 'applicant'),
              policy: captureAny(named: 'policy'),
            )).captured;
        final usedPolicy = captured[1] as LoanPolicyModel;
        expect(usedPolicy.minIncome, 50000);
        expect(usedPolicy.maxLoanAmount, 1000000);
      },
    );

    blocTest<EligibilityBloc, EligibilityState>(
      'emits [Loading, Failure] when policy loading fails',
      build: () {
        when(() => mockLoadPolicies()).thenAnswer(
          (_) async => const Left(LocalDataFailure('load error')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(EvaluateEligibility(applicant: tApplicant)),
      expect: () => [
        const EligibilityLoading(),
        const EligibilityFailure(message: 'load error'),
      ],
    );

    blocTest<EligibilityBloc, EligibilityState>(
      'emits [Loading, Failure] when policies list is empty',
      build: () {
        when(() => mockLoadPolicies()).thenAnswer(
          (_) async => const Right([]),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(EvaluateEligibility(applicant: tApplicant)),
      expect: () => [
        const EligibilityLoading(),
        const EligibilityFailure(message: 'No loan policies available'),
      ],
    );

    blocTest<EligibilityBloc, EligibilityState>(
      'emits [Loading, Failure] when income too low for any tier',
      build: () {
        when(() => mockLoadPolicies()).thenAnswer(
          (_) async => Right(tPolicies),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(EvaluateEligibility(
        applicant: ApplicantModel(
          fullName: 'Test User',
          panNumber: 'ABCDE1234F',
          monthlyIncome: 10000,
          requestedLoanAmount: 50000,
          employmentType: 'Salaried',
          creditHistory: 1,
          selfiePath: '/path/selfie.jpg',
        ),
      )),
      expect: () => [
        const EligibilityLoading(),
        const EligibilityFailure(
          message: 'Income does not meet minimum requirement for any loan tier',
        ),
      ],
    );

    blocTest<EligibilityBloc, EligibilityState>(
      'emits [Loading, Failure] when evaluation usecase fails',
      build: () {
        when(() => mockLoadPolicies()).thenAnswer(
          (_) async => Right(tPolicies),
        );
        when(() => mockEvaluate(
              applicant: any(named: 'applicant'),
              policy: any(named: 'policy'),
            )).thenAnswer(
          (_) async => const Left(ValidationFailure('evaluation error')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(EvaluateEligibility(applicant: tApplicant)),
      expect: () => [
        const EligibilityLoading(),
        const EligibilityFailure(message: 'evaluation error'),
      ],
    );
  });
}
