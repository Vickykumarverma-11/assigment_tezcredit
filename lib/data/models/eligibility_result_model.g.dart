// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eligibility_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EligibilityResultModelImpl _$$EligibilityResultModelImplFromJson(
  Map<String, dynamic> json,
) => _$EligibilityResultModelImpl(
  isApproved: json['is_approved'] as bool,
  eligibleAmount: (json['eligible_amount'] as num).toDouble(),
  estimatedEmi: (json['estimated_emi'] as num).toDouble(),
  tenureMonths: (json['tenure_months'] as num?)?.toInt() ?? 0,
  rejectionReasons:
      (json['rejection_reasons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$EligibilityResultModelImplToJson(
  _$EligibilityResultModelImpl instance,
) => <String, dynamic>{
  'is_approved': instance.isApproved,
  'eligible_amount': instance.eligibleAmount,
  'estimated_emi': instance.estimatedEmi,
  'tenure_months': instance.tenureMonths,
  'rejection_reasons': instance.rejectionReasons,
};
