// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_policy_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoanPolicyModel _$LoanPolicyModelFromJson(Map<String, dynamic> json) {
  return _LoanPolicyModel.fromJson(json);
}

/// @nodoc
mixin _$LoanPolicyModel {
  @JsonKey(name: 'min_income')
  double get minIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_loan_amount')
  double get maxLoanAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenure_months')
  int get tenureMonths => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit_history_required')
  int get creditHistoryRequired => throw _privateConstructorUsedError;

  /// Serializes this LoanPolicyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoanPolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoanPolicyModelCopyWith<LoanPolicyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanPolicyModelCopyWith<$Res> {
  factory $LoanPolicyModelCopyWith(
    LoanPolicyModel value,
    $Res Function(LoanPolicyModel) then,
  ) = _$LoanPolicyModelCopyWithImpl<$Res, LoanPolicyModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'min_income') double minIncome,
    @JsonKey(name: 'max_loan_amount') double maxLoanAmount,
    @JsonKey(name: 'tenure_months') int tenureMonths,
    @JsonKey(name: 'credit_history_required') int creditHistoryRequired,
  });
}

/// @nodoc
class _$LoanPolicyModelCopyWithImpl<$Res, $Val extends LoanPolicyModel>
    implements $LoanPolicyModelCopyWith<$Res> {
  _$LoanPolicyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoanPolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minIncome = null,
    Object? maxLoanAmount = null,
    Object? tenureMonths = null,
    Object? creditHistoryRequired = null,
  }) {
    return _then(
      _value.copyWith(
            minIncome: null == minIncome
                ? _value.minIncome
                : minIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            maxLoanAmount: null == maxLoanAmount
                ? _value.maxLoanAmount
                : maxLoanAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            tenureMonths: null == tenureMonths
                ? _value.tenureMonths
                : tenureMonths // ignore: cast_nullable_to_non_nullable
                      as int,
            creditHistoryRequired: null == creditHistoryRequired
                ? _value.creditHistoryRequired
                : creditHistoryRequired // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoanPolicyModelImplCopyWith<$Res>
    implements $LoanPolicyModelCopyWith<$Res> {
  factory _$$LoanPolicyModelImplCopyWith(
    _$LoanPolicyModelImpl value,
    $Res Function(_$LoanPolicyModelImpl) then,
  ) = __$$LoanPolicyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'min_income') double minIncome,
    @JsonKey(name: 'max_loan_amount') double maxLoanAmount,
    @JsonKey(name: 'tenure_months') int tenureMonths,
    @JsonKey(name: 'credit_history_required') int creditHistoryRequired,
  });
}

/// @nodoc
class __$$LoanPolicyModelImplCopyWithImpl<$Res>
    extends _$LoanPolicyModelCopyWithImpl<$Res, _$LoanPolicyModelImpl>
    implements _$$LoanPolicyModelImplCopyWith<$Res> {
  __$$LoanPolicyModelImplCopyWithImpl(
    _$LoanPolicyModelImpl _value,
    $Res Function(_$LoanPolicyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoanPolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minIncome = null,
    Object? maxLoanAmount = null,
    Object? tenureMonths = null,
    Object? creditHistoryRequired = null,
  }) {
    return _then(
      _$LoanPolicyModelImpl(
        minIncome: null == minIncome
            ? _value.minIncome
            : minIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        maxLoanAmount: null == maxLoanAmount
            ? _value.maxLoanAmount
            : maxLoanAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        tenureMonths: null == tenureMonths
            ? _value.tenureMonths
            : tenureMonths // ignore: cast_nullable_to_non_nullable
                  as int,
        creditHistoryRequired: null == creditHistoryRequired
            ? _value.creditHistoryRequired
            : creditHistoryRequired // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanPolicyModelImpl implements _LoanPolicyModel {
  const _$LoanPolicyModelImpl({
    @JsonKey(name: 'min_income') required this.minIncome,
    @JsonKey(name: 'max_loan_amount') required this.maxLoanAmount,
    @JsonKey(name: 'tenure_months') required this.tenureMonths,
    @JsonKey(name: 'credit_history_required')
    required this.creditHistoryRequired,
  });

  factory _$LoanPolicyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanPolicyModelImplFromJson(json);

  @override
  @JsonKey(name: 'min_income')
  final double minIncome;
  @override
  @JsonKey(name: 'max_loan_amount')
  final double maxLoanAmount;
  @override
  @JsonKey(name: 'tenure_months')
  final int tenureMonths;
  @override
  @JsonKey(name: 'credit_history_required')
  final int creditHistoryRequired;

  @override
  String toString() {
    return 'LoanPolicyModel(minIncome: $minIncome, maxLoanAmount: $maxLoanAmount, tenureMonths: $tenureMonths, creditHistoryRequired: $creditHistoryRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanPolicyModelImpl &&
            (identical(other.minIncome, minIncome) ||
                other.minIncome == minIncome) &&
            (identical(other.maxLoanAmount, maxLoanAmount) ||
                other.maxLoanAmount == maxLoanAmount) &&
            (identical(other.tenureMonths, tenureMonths) ||
                other.tenureMonths == tenureMonths) &&
            (identical(other.creditHistoryRequired, creditHistoryRequired) ||
                other.creditHistoryRequired == creditHistoryRequired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    minIncome,
    maxLoanAmount,
    tenureMonths,
    creditHistoryRequired,
  );

  /// Create a copy of LoanPolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanPolicyModelImplCopyWith<_$LoanPolicyModelImpl> get copyWith =>
      __$$LoanPolicyModelImplCopyWithImpl<_$LoanPolicyModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanPolicyModelImplToJson(this);
  }
}

abstract class _LoanPolicyModel implements LoanPolicyModel {
  const factory _LoanPolicyModel({
    @JsonKey(name: 'min_income') required final double minIncome,
    @JsonKey(name: 'max_loan_amount') required final double maxLoanAmount,
    @JsonKey(name: 'tenure_months') required final int tenureMonths,
    @JsonKey(name: 'credit_history_required')
    required final int creditHistoryRequired,
  }) = _$LoanPolicyModelImpl;

  factory _LoanPolicyModel.fromJson(Map<String, dynamic> json) =
      _$LoanPolicyModelImpl.fromJson;

  @override
  @JsonKey(name: 'min_income')
  double get minIncome;
  @override
  @JsonKey(name: 'max_loan_amount')
  double get maxLoanAmount;
  @override
  @JsonKey(name: 'tenure_months')
  int get tenureMonths;
  @override
  @JsonKey(name: 'credit_history_required')
  int get creditHistoryRequired;

  /// Create a copy of LoanPolicyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoanPolicyModelImplCopyWith<_$LoanPolicyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
