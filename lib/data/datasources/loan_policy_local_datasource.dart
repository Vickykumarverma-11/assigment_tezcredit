import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:assigment_tezcredit/core/constants/app_constants.dart';
import 'package:assigment_tezcredit/data/models/loan_policy_model.dart';

abstract class LoanPolicyLocalDatasource {
  Future<List<LoanPolicyModel>> loadLoanPolicies();
}

class LoanPolicyLocalDatasourceImpl implements LoanPolicyLocalDatasource {
  @override
  Future<List<LoanPolicyModel>> loadLoanPolicies() async {
    try {
      final jsonString = await rootBundle.loadString(
        AppConstants.loanPolicyAssetPath,
      );

      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList
          .map((item) =>
              LoanPolicyModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load loan policies: $e');
    }
  }
}
