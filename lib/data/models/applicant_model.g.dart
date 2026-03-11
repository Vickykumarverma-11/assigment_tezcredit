// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicantModelImpl _$$ApplicantModelImplFromJson(Map<String, dynamic> json) =>
    _$ApplicantModelImpl(
      fullName: json['full_name'] as String,
      panNumber: json['pan_number'] as String,
      monthlyIncome: (json['monthly_income'] as num).toDouble(),
      requestedLoanAmount: (json['requested_loan_amount'] as num).toDouble(),
      employmentType: json['employment_type'] as String,
      creditHistory: (json['credit_history'] as num).toInt(),
      selfiePath: json['selfie_path'] as String? ?? '',
    );

Map<String, dynamic> _$$ApplicantModelImplToJson(
  _$ApplicantModelImpl instance,
) => <String, dynamic>{
  'full_name': instance.fullName,
  'pan_number': instance.panNumber,
  'monthly_income': instance.monthlyIncome,
  'requested_loan_amount': instance.requestedLoanAmount,
  'employment_type': instance.employmentType,
  'credit_history': instance.creditHistory,
  'selfie_path': instance.selfiePath,
};
