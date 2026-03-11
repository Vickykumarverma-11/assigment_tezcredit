import 'package:freezed_annotation/freezed_annotation.dart';

part 'applicant_model.freezed.dart';
part 'applicant_model.g.dart';

@freezed
class ApplicantModel with _$ApplicantModel {
  const factory ApplicantModel({
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'pan_number') required String panNumber,
    @JsonKey(name: 'monthly_income') required double monthlyIncome,
    @JsonKey(name: 'requested_loan_amount') required double requestedLoanAmount,
    @JsonKey(name: 'employment_type') required String employmentType,
    @JsonKey(name: 'credit_history') required int creditHistory,
    @JsonKey(name: 'selfie_path') @Default('') String selfiePath,
  }) = _ApplicantModel;

  factory ApplicantModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicantModelFromJson(json);
}
