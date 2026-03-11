// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eligibility_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EligibilityResultModel _$EligibilityResultModelFromJson(
  Map<String, dynamic> json,
) {
  return _EligibilityResultModel.fromJson(json);
}

/// @nodoc
mixin _$EligibilityResultModel {
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'eligible_amount')
  double get eligibleAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_emi')
  double get estimatedEmi => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenure_months')
  int get tenureMonths => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reasons')
  List<String> get rejectionReasons => throw _privateConstructorUsedError;

  /// Serializes this EligibilityResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EligibilityResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EligibilityResultModelCopyWith<EligibilityResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EligibilityResultModelCopyWith<$Res> {
  factory $EligibilityResultModelCopyWith(
    EligibilityResultModel value,
    $Res Function(EligibilityResultModel) then,
  ) = _$EligibilityResultModelCopyWithImpl<$Res, EligibilityResultModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'is_approved') bool isApproved,
    @JsonKey(name: 'eligible_amount') double eligibleAmount,
    @JsonKey(name: 'estimated_emi') double estimatedEmi,
    @JsonKey(name: 'tenure_months') int tenureMonths,
    @JsonKey(name: 'rejection_reasons') List<String> rejectionReasons,
  });
}

/// @nodoc
class _$EligibilityResultModelCopyWithImpl<
  $Res,
  $Val extends EligibilityResultModel
>
    implements $EligibilityResultModelCopyWith<$Res> {
  _$EligibilityResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EligibilityResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isApproved = null,
    Object? eligibleAmount = null,
    Object? estimatedEmi = null,
    Object? tenureMonths = null,
    Object? rejectionReasons = null,
  }) {
    return _then(
      _value.copyWith(
            isApproved: null == isApproved
                ? _value.isApproved
                : isApproved // ignore: cast_nullable_to_non_nullable
                      as bool,
            eligibleAmount: null == eligibleAmount
                ? _value.eligibleAmount
                : eligibleAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            estimatedEmi: null == estimatedEmi
                ? _value.estimatedEmi
                : estimatedEmi // ignore: cast_nullable_to_non_nullable
                      as double,
            tenureMonths: null == tenureMonths
                ? _value.tenureMonths
                : tenureMonths // ignore: cast_nullable_to_non_nullable
                      as int,
            rejectionReasons: null == rejectionReasons
                ? _value.rejectionReasons
                : rejectionReasons // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EligibilityResultModelImplCopyWith<$Res>
    implements $EligibilityResultModelCopyWith<$Res> {
  factory _$$EligibilityResultModelImplCopyWith(
    _$EligibilityResultModelImpl value,
    $Res Function(_$EligibilityResultModelImpl) then,
  ) = __$$EligibilityResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'is_approved') bool isApproved,
    @JsonKey(name: 'eligible_amount') double eligibleAmount,
    @JsonKey(name: 'estimated_emi') double estimatedEmi,
    @JsonKey(name: 'tenure_months') int tenureMonths,
    @JsonKey(name: 'rejection_reasons') List<String> rejectionReasons,
  });
}

/// @nodoc
class __$$EligibilityResultModelImplCopyWithImpl<$Res>
    extends
        _$EligibilityResultModelCopyWithImpl<$Res, _$EligibilityResultModelImpl>
    implements _$$EligibilityResultModelImplCopyWith<$Res> {
  __$$EligibilityResultModelImplCopyWithImpl(
    _$EligibilityResultModelImpl _value,
    $Res Function(_$EligibilityResultModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EligibilityResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isApproved = null,
    Object? eligibleAmount = null,
    Object? estimatedEmi = null,
    Object? tenureMonths = null,
    Object? rejectionReasons = null,
  }) {
    return _then(
      _$EligibilityResultModelImpl(
        isApproved: null == isApproved
            ? _value.isApproved
            : isApproved // ignore: cast_nullable_to_non_nullable
                  as bool,
        eligibleAmount: null == eligibleAmount
            ? _value.eligibleAmount
            : eligibleAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        estimatedEmi: null == estimatedEmi
            ? _value.estimatedEmi
            : estimatedEmi // ignore: cast_nullable_to_non_nullable
                  as double,
        tenureMonths: null == tenureMonths
            ? _value.tenureMonths
            : tenureMonths // ignore: cast_nullable_to_non_nullable
                  as int,
        rejectionReasons: null == rejectionReasons
            ? _value._rejectionReasons
            : rejectionReasons // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EligibilityResultModelImpl implements _EligibilityResultModel {
  const _$EligibilityResultModelImpl({
    @JsonKey(name: 'is_approved') required this.isApproved,
    @JsonKey(name: 'eligible_amount') required this.eligibleAmount,
    @JsonKey(name: 'estimated_emi') required this.estimatedEmi,
    @JsonKey(name: 'tenure_months') this.tenureMonths = 0,
    @JsonKey(name: 'rejection_reasons')
    final List<String> rejectionReasons = const [],
  }) : _rejectionReasons = rejectionReasons;

  factory _$EligibilityResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EligibilityResultModelImplFromJson(json);

  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'eligible_amount')
  final double eligibleAmount;
  @override
  @JsonKey(name: 'estimated_emi')
  final double estimatedEmi;
  @override
  @JsonKey(name: 'tenure_months')
  final int tenureMonths;
  final List<String> _rejectionReasons;
  @override
  @JsonKey(name: 'rejection_reasons')
  List<String> get rejectionReasons {
    if (_rejectionReasons is EqualUnmodifiableListView)
      return _rejectionReasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rejectionReasons);
  }

  @override
  String toString() {
    return 'EligibilityResultModel(isApproved: $isApproved, eligibleAmount: $eligibleAmount, estimatedEmi: $estimatedEmi, tenureMonths: $tenureMonths, rejectionReasons: $rejectionReasons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EligibilityResultModelImpl &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.eligibleAmount, eligibleAmount) ||
                other.eligibleAmount == eligibleAmount) &&
            (identical(other.estimatedEmi, estimatedEmi) ||
                other.estimatedEmi == estimatedEmi) &&
            (identical(other.tenureMonths, tenureMonths) ||
                other.tenureMonths == tenureMonths) &&
            const DeepCollectionEquality().equals(
              other._rejectionReasons,
              _rejectionReasons,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isApproved,
    eligibleAmount,
    estimatedEmi,
    tenureMonths,
    const DeepCollectionEquality().hash(_rejectionReasons),
  );

  /// Create a copy of EligibilityResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EligibilityResultModelImplCopyWith<_$EligibilityResultModelImpl>
  get copyWith =>
      __$$EligibilityResultModelImplCopyWithImpl<_$EligibilityResultModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EligibilityResultModelImplToJson(this);
  }
}

abstract class _EligibilityResultModel implements EligibilityResultModel {
  const factory _EligibilityResultModel({
    @JsonKey(name: 'is_approved') required final bool isApproved,
    @JsonKey(name: 'eligible_amount') required final double eligibleAmount,
    @JsonKey(name: 'estimated_emi') required final double estimatedEmi,
    @JsonKey(name: 'tenure_months') final int tenureMonths,
    @JsonKey(name: 'rejection_reasons') final List<String> rejectionReasons,
  }) = _$EligibilityResultModelImpl;

  factory _EligibilityResultModel.fromJson(Map<String, dynamic> json) =
      _$EligibilityResultModelImpl.fromJson;

  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'eligible_amount')
  double get eligibleAmount;
  @override
  @JsonKey(name: 'estimated_emi')
  double get estimatedEmi;
  @override
  @JsonKey(name: 'tenure_months')
  int get tenureMonths;
  @override
  @JsonKey(name: 'rejection_reasons')
  List<String> get rejectionReasons;

  /// Create a copy of EligibilityResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EligibilityResultModelImplCopyWith<_$EligibilityResultModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
