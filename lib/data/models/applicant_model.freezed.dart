// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'applicant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplicantModel _$ApplicantModelFromJson(Map<String, dynamic> json) {
  return _ApplicantModel.fromJson(json);
}

/// @nodoc
mixin _$ApplicantModel {
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'pan_number')
  String get panNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_income')
  double get monthlyIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_loan_amount')
  double get requestedLoanAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'employment_type')
  String get employmentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit_history')
  int get creditHistory => throw _privateConstructorUsedError;
  @JsonKey(name: 'selfie_path')
  String get selfiePath => throw _privateConstructorUsedError;

  /// Serializes this ApplicantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicantModelCopyWith<ApplicantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicantModelCopyWith<$Res> {
  factory $ApplicantModelCopyWith(
    ApplicantModel value,
    $Res Function(ApplicantModel) then,
  ) = _$ApplicantModelCopyWithImpl<$Res, ApplicantModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'full_name') String fullName,
    @JsonKey(name: 'pan_number') String panNumber,
    @JsonKey(name: 'monthly_income') double monthlyIncome,
    @JsonKey(name: 'requested_loan_amount') double requestedLoanAmount,
    @JsonKey(name: 'employment_type') String employmentType,
    @JsonKey(name: 'credit_history') int creditHistory,
    @JsonKey(name: 'selfie_path') String selfiePath,
  });
}

/// @nodoc
class _$ApplicantModelCopyWithImpl<$Res, $Val extends ApplicantModel>
    implements $ApplicantModelCopyWith<$Res> {
  _$ApplicantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? panNumber = null,
    Object? monthlyIncome = null,
    Object? requestedLoanAmount = null,
    Object? employmentType = null,
    Object? creditHistory = null,
    Object? selfiePath = null,
  }) {
    return _then(
      _value.copyWith(
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            panNumber: null == panNumber
                ? _value.panNumber
                : panNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            monthlyIncome: null == monthlyIncome
                ? _value.monthlyIncome
                : monthlyIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            requestedLoanAmount: null == requestedLoanAmount
                ? _value.requestedLoanAmount
                : requestedLoanAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            employmentType: null == employmentType
                ? _value.employmentType
                : employmentType // ignore: cast_nullable_to_non_nullable
                      as String,
            creditHistory: null == creditHistory
                ? _value.creditHistory
                : creditHistory // ignore: cast_nullable_to_non_nullable
                      as int,
            selfiePath: null == selfiePath
                ? _value.selfiePath
                : selfiePath // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicantModelImplCopyWith<$Res>
    implements $ApplicantModelCopyWith<$Res> {
  factory _$$ApplicantModelImplCopyWith(
    _$ApplicantModelImpl value,
    $Res Function(_$ApplicantModelImpl) then,
  ) = __$$ApplicantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'full_name') String fullName,
    @JsonKey(name: 'pan_number') String panNumber,
    @JsonKey(name: 'monthly_income') double monthlyIncome,
    @JsonKey(name: 'requested_loan_amount') double requestedLoanAmount,
    @JsonKey(name: 'employment_type') String employmentType,
    @JsonKey(name: 'credit_history') int creditHistory,
    @JsonKey(name: 'selfie_path') String selfiePath,
  });
}

/// @nodoc
class __$$ApplicantModelImplCopyWithImpl<$Res>
    extends _$ApplicantModelCopyWithImpl<$Res, _$ApplicantModelImpl>
    implements _$$ApplicantModelImplCopyWith<$Res> {
  __$$ApplicantModelImplCopyWithImpl(
    _$ApplicantModelImpl _value,
    $Res Function(_$ApplicantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? panNumber = null,
    Object? monthlyIncome = null,
    Object? requestedLoanAmount = null,
    Object? employmentType = null,
    Object? creditHistory = null,
    Object? selfiePath = null,
  }) {
    return _then(
      _$ApplicantModelImpl(
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        panNumber: null == panNumber
            ? _value.panNumber
            : panNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        monthlyIncome: null == monthlyIncome
            ? _value.monthlyIncome
            : monthlyIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        requestedLoanAmount: null == requestedLoanAmount
            ? _value.requestedLoanAmount
            : requestedLoanAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        employmentType: null == employmentType
            ? _value.employmentType
            : employmentType // ignore: cast_nullable_to_non_nullable
                  as String,
        creditHistory: null == creditHistory
            ? _value.creditHistory
            : creditHistory // ignore: cast_nullable_to_non_nullable
                  as int,
        selfiePath: null == selfiePath
            ? _value.selfiePath
            : selfiePath // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicantModelImpl implements _ApplicantModel {
  const _$ApplicantModelImpl({
    @JsonKey(name: 'full_name') required this.fullName,
    @JsonKey(name: 'pan_number') required this.panNumber,
    @JsonKey(name: 'monthly_income') required this.monthlyIncome,
    @JsonKey(name: 'requested_loan_amount') required this.requestedLoanAmount,
    @JsonKey(name: 'employment_type') required this.employmentType,
    @JsonKey(name: 'credit_history') required this.creditHistory,
    @JsonKey(name: 'selfie_path') this.selfiePath = '',
  });

  factory _$ApplicantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicantModelImplFromJson(json);

  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  @JsonKey(name: 'pan_number')
  final String panNumber;
  @override
  @JsonKey(name: 'monthly_income')
  final double monthlyIncome;
  @override
  @JsonKey(name: 'requested_loan_amount')
  final double requestedLoanAmount;
  @override
  @JsonKey(name: 'employment_type')
  final String employmentType;
  @override
  @JsonKey(name: 'credit_history')
  final int creditHistory;
  @override
  @JsonKey(name: 'selfie_path')
  final String selfiePath;

  @override
  String toString() {
    return 'ApplicantModel(fullName: $fullName, panNumber: $panNumber, monthlyIncome: $monthlyIncome, requestedLoanAmount: $requestedLoanAmount, employmentType: $employmentType, creditHistory: $creditHistory, selfiePath: $selfiePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicantModelImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.panNumber, panNumber) ||
                other.panNumber == panNumber) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.requestedLoanAmount, requestedLoanAmount) ||
                other.requestedLoanAmount == requestedLoanAmount) &&
            (identical(other.employmentType, employmentType) ||
                other.employmentType == employmentType) &&
            (identical(other.creditHistory, creditHistory) ||
                other.creditHistory == creditHistory) &&
            (identical(other.selfiePath, selfiePath) ||
                other.selfiePath == selfiePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fullName,
    panNumber,
    monthlyIncome,
    requestedLoanAmount,
    employmentType,
    creditHistory,
    selfiePath,
  );

  /// Create a copy of ApplicantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicantModelImplCopyWith<_$ApplicantModelImpl> get copyWith =>
      __$$ApplicantModelImplCopyWithImpl<_$ApplicantModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicantModelImplToJson(this);
  }
}

abstract class _ApplicantModel implements ApplicantModel {
  const factory _ApplicantModel({
    @JsonKey(name: 'full_name') required final String fullName,
    @JsonKey(name: 'pan_number') required final String panNumber,
    @JsonKey(name: 'monthly_income') required final double monthlyIncome,
    @JsonKey(name: 'requested_loan_amount')
    required final double requestedLoanAmount,
    @JsonKey(name: 'employment_type') required final String employmentType,
    @JsonKey(name: 'credit_history') required final int creditHistory,
    @JsonKey(name: 'selfie_path') final String selfiePath,
  }) = _$ApplicantModelImpl;

  factory _ApplicantModel.fromJson(Map<String, dynamic> json) =
      _$ApplicantModelImpl.fromJson;

  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  @JsonKey(name: 'pan_number')
  String get panNumber;
  @override
  @JsonKey(name: 'monthly_income')
  double get monthlyIncome;
  @override
  @JsonKey(name: 'requested_loan_amount')
  double get requestedLoanAmount;
  @override
  @JsonKey(name: 'employment_type')
  String get employmentType;
  @override
  @JsonKey(name: 'credit_history')
  int get creditHistory;
  @override
  @JsonKey(name: 'selfie_path')
  String get selfiePath;

  /// Create a copy of ApplicantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicantModelImplCopyWith<_$ApplicantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
