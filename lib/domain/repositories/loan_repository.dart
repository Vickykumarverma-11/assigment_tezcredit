import 'package:dartz/dartz.dart';

import 'package:assigment_tezcredit/core/error/failures.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';
import 'package:assigment_tezcredit/data/models/eligibility_result_model.dart';
import 'package:assigment_tezcredit/data/models/loan_policy_model.dart';

abstract class LoanRepository {
  Future<Either<Failure, List<LoanPolicyModel>>> loadLoanPolicies();

  Future<Either<Failure, EligibilityResultModel>> evaluateEligibility(
    ApplicantModel applicant,
    LoanPolicyModel policy,
  );
}
