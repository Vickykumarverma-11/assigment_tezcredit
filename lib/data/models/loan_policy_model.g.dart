// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_policy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanPolicyModelImpl _$$LoanPolicyModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoanPolicyModelImpl(
  minIncome: (json['min_income'] as num).toDouble(),
  maxLoanAmount: (json['max_loan_amount'] as num).toDouble(),
  tenureMonths: (json['tenure_months'] as num).toInt(),
  creditHistoryRequired: (json['credit_history_required'] as num).toInt(),
);

Map<String, dynamic> _$$LoanPolicyModelImplToJson(
  _$LoanPolicyModelImpl instance,
) => <String, dynamic>{
  'min_income': instance.minIncome,
  'max_loan_amount': instance.maxLoanAmount,
  'tenure_months': instance.tenureMonths,
  'credit_history_required': instance.creditHistoryRequired,
};
