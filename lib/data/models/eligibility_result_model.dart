import 'package:freezed_annotation/freezed_annotation.dart';

part 'eligibility_result_model.freezed.dart';
part 'eligibility_result_model.g.dart';

@freezed
class EligibilityResultModel with _$EligibilityResultModel {
  const factory EligibilityResultModel({
    @JsonKey(name: 'is_approved') required bool isApproved,
    @JsonKey(name: 'eligible_amount') required double eligibleAmount,
    @JsonKey(name: 'estimated_emi') required double estimatedEmi,
    @JsonKey(name: 'rejection_reasons') @Default([]) List<String> rejectionReasons,
  }) = _EligibilityResultModel;

  factory EligibilityResultModel.fromJson(Map<String, dynamic> json) =>
      _$EligibilityResultModelFromJson(json);
}
