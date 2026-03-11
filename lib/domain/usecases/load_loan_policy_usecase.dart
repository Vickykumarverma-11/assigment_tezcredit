import 'package:dartz/dartz.dart';

import 'package:assigment_tezcredit/core/error/failures.dart';
import 'package:assigment_tezcredit/data/models/loan_policy_model.dart';
import 'package:assigment_tezcredit/domain/repositories/loan_repository.dart';

class LoadLoanPolicyUsecase {
  final LoanRepository _repository;

  LoadLoanPolicyUsecase({required LoanRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<LoanPolicyModel>>> call() async {
    return await _repository.loadLoanPolicies();
  }
}
