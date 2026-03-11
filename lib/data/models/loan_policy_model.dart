import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_policy_model.freezed.dart';
part 'loan_policy_model.g.dart';

@freezed
class LoanPolicyModel with _$LoanPolicyModel {
  const factory LoanPolicyModel({
    @JsonKey(name: 'min_income') required double minIncome,
    @JsonKey(name: 'max_loan_amount') required double maxLoanAmount,
    @JsonKey(name: 'tenure_months') required int tenureMonths,
    @JsonKey(name: 'credit_history_required') required int creditHistoryRequired,
  }) = _LoanPolicyModel;

  factory LoanPolicyModel.fromJson(Map<String, dynamic> json) =>
      _$LoanPolicyModelFromJson(json);
}
