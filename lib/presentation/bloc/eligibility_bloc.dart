import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/data/models/eligibility_result_model.dart';
import 'package:assigment_tezcredit/domain/usecases/evaluate_eligibility_usecase.dart';
import 'package:assigment_tezcredit/domain/usecases/load_loan_policy_usecase.dart';

// ─── Events ───────────────────────────────────────────────

abstract class EligibilityEvent extends Equatable {
  const EligibilityEvent();

  @override
  List<Object?> get props => [];
}

class EvaluateEligibility extends EligibilityEvent {
  final ApplicantModel applicant;

  const EvaluateEligibility({required this.applicant});

  @override
  List<Object?> get props => [applicant];
}

// ─── States ───────────────────────────────────────────────

abstract class EligibilityState extends Equatable {
  const EligibilityState();

  @override
  List<Object?> get props => [];
}

class EligibilityInitial extends EligibilityState {
  const EligibilityInitial();
}

class EligibilityLoading extends EligibilityState {
  const EligibilityLoading();
}

class EligibilitySuccess extends EligibilityState {
  final EligibilityResultModel result;

  const EligibilitySuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class EligibilityFailure extends EligibilityState {
  final String message;

  const EligibilityFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── Bloc ─────────────────────────────────────────────────

class EligibilityBloc extends Bloc<EligibilityEvent, EligibilityState> {
  final EvaluateEligibilityUsecase _evaluateEligibilityUsecase;
  final LoadLoanPolicyUsecase _loadLoanPolicyUsecase;

  EligibilityBloc({
    required EvaluateEligibilityUsecase evaluateEligibilityUsecase,
    required LoadLoanPolicyUsecase loadLoanPolicyUsecase,
  })  : _evaluateEligibilityUsecase = evaluateEligibilityUsecase,
        _loadLoanPolicyUsecase = loadLoanPolicyUsecase,
        super(const EligibilityInitial()) {
    on<EvaluateEligibility>(_onEvaluateEligibility);
  }

  Future<void> _onEvaluateEligibility(
    EvaluateEligibility event,
    Emitter<EligibilityState> emit,
  ) async {
    emit(const EligibilityLoading());

    // Load loan policies first
    final policiesResult = await _loadLoanPolicyUsecase();

    await policiesResult.fold(
      (failure) async {
        emit(EligibilityFailure(message: failure.message));
      },
      (policies) async {
        if (policies.isEmpty) {
          emit(const EligibilityFailure(message: 'No loan policies available'));
          return;
        }

        // Pick the best matching policy tier for the applicant's income.
        // Policies are sorted by min_income ascending in the JSON.
        // Select the highest tier where applicant meets the min_income.
        final matchingPolicies = policies
            .where((p) => event.applicant.monthlyIncome >= p.minIncome)
            .toList();

        if (matchingPolicies.isEmpty) {
          emit(const EligibilityFailure(
            message: 'Income does not meet minimum requirement for any loan tier',
          ));
          return;
        }

        final policy = matchingPolicies.last;

        final eligibilityResult = await _evaluateEligibilityUsecase(
          applicant: event.applicant,
          policy: policy,
        );

        eligibilityResult.fold(
          (failure) {
            emit(EligibilityFailure(message: failure.message));
          },
          (result) {
            emit(EligibilitySuccess(result: result));
          },
        );
      },
    );
  }
}
