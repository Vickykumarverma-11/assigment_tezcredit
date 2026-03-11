import 'package:dartz/dartz.dart';

import 'package:assigment_tezcredit/core/error/failures.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/data/models/eligibility_result_model.dart';
import 'package:assigment_tezcredit/data/models/loan_policy_model.dart';
import 'package:assigment_tezcredit/domain/repositories/loan_repository.dart';

class EvaluateEligibilityUsecase {
  final LoanRepository _repository;

  EvaluateEligibilityUsecase({required LoanRepository repository})
      : _repository = repository;

  Future<Either<Failure, EligibilityResultModel>> call({
    required ApplicantModel applicant,
    required LoanPolicyModel policy,
  }) async {
    return await _repository.evaluateEligibility(applicant, policy);
  }
}
