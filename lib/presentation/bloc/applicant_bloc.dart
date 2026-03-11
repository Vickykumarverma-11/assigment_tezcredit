import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:assigment_tezcredit/core/security/encryption_service.dart';
import 'package:assigment_tezcredit/core/utils/validators.dart';
import 'package:assigment_tezcredit/data/models/applicant_model.dart';

// ─── Events ───────────────────────────────────────────────

abstract class ApplicantEvent extends Equatable {
  const ApplicantEvent();

  @override
  List<Object?> get props => [];
}

class ApplicantFormChanged extends ApplicantEvent {
  final String fullName;
  final String panNumber;
  final String monthlyIncome;
  final String requestedLoanAmount;
  final String employmentType;
  final int creditHistory;

  const ApplicantFormChanged({
    required this.fullName,
    required this.panNumber,
    required this.monthlyIncome,
    required this.requestedLoanAmount,
    required this.employmentType,
    required this.creditHistory,
  });

  @override
  List<Object?> get props => [
        fullName,
        panNumber,
        monthlyIncome,
        requestedLoanAmount,
        employmentType,
        creditHistory,
      ];
}

class ApplicantFormSubmitted extends ApplicantEvent {
  final String fullName;
  final String panNumber;
  final String monthlyIncome;
  final String requestedLoanAmount;
  final String employmentType;
  final int creditHistory;

  const ApplicantFormSubmitted({
    required this.fullName,
    required this.panNumber,
    required this.monthlyIncome,
    required this.requestedLoanAmount,
    required this.employmentType,
    required this.creditHistory,
  });

  @override
  List<Object?> get props => [
        fullName,
        panNumber,
        monthlyIncome,
        requestedLoanAmount,
        employmentType,
        creditHistory,
      ];
}

// ─── States ───────────────────────────────────────────────

abstract class ApplicantState extends Equatable {
  const ApplicantState();

  @override
  List<Object?> get props => [];
}

class ApplicantInitial extends ApplicantState {
  const ApplicantInitial();
}

class ApplicantValid extends ApplicantState {
  final ApplicantModel applicant;

  const ApplicantValid({required this.applicant});

  @override
  List<Object?> get props => [applicant];
}

class ApplicantInvalid extends ApplicantState {
  final Map<String, String> errors;

  const ApplicantInvalid({required this.errors});

  @override
  List<Object?> get props => [errors];
}

// ─── Bloc ─────────────────────────────────────────────────

class ApplicantBloc extends Bloc<ApplicantEvent, ApplicantState> {
  final EncryptionService _encryptionService;

  String _lastEncryptedIncome = '';
  String _lastEncryptedLoanAmount = '';

  String get lastEncryptedIncome => _lastEncryptedIncome;
  String get lastEncryptedLoanAmount => _lastEncryptedLoanAmount;

  ApplicantBloc({required EncryptionService encryptionService})
      : _encryptionService = encryptionService,
        super(const ApplicantInitial()) {
    on<ApplicantFormChanged>(_onFormChanged);
    on<ApplicantFormSubmitted>(_onFormSubmitted);
  }

  void _onFormChanged(
    ApplicantFormChanged event,
    Emitter<ApplicantState> emit,
  ) {
    final errors = _validate(
      fullName: event.fullName,
      panNumber: event.panNumber,
      monthlyIncome: event.monthlyIncome,
      requestedLoanAmount: event.requestedLoanAmount,
    );

    if (errors.isEmpty) {
      emit(ApplicantValid(
        applicant: _buildApplicant(
          fullName: event.fullName,
          panNumber: event.panNumber,
          monthlyIncome: event.monthlyIncome,
          requestedLoanAmount: event.requestedLoanAmount,
          employmentType: event.employmentType,
          creditHistory: event.creditHistory,
        ),
      ));
    } else {
      emit(ApplicantInvalid(errors: errors));
    }
  }

  void _onFormSubmitted(
    ApplicantFormSubmitted event,
    Emitter<ApplicantState> emit,
  ) {
    final sanitizedName = Validators.sanitizeName(
      Validators.sanitizeInput(event.fullName),
    );
    final sanitizedPan = Validators.sanitizePan(
      Validators.sanitizeInput(event.panNumber),
    );
    final sanitizedIncome = Validators.sanitizeNumeric(event.monthlyIncome);
    final sanitizedLoanAmount = Validators.sanitizeNumeric(
      event.requestedLoanAmount,
    );

    final errors = _validate(
      fullName: sanitizedName,
      panNumber: sanitizedPan,
      monthlyIncome: sanitizedIncome,
      requestedLoanAmount: sanitizedLoanAmount,
    );

    if (errors.isNotEmpty) {
      emit(ApplicantInvalid(errors: errors));
      return;
    }

    // Encrypt sensitive fields before storage
    final encryptedPan = _encryptionService.encryptData(sanitizedPan);
    final encryptedIncome = _encryptionService.encryptData(sanitizedIncome);
    final encryptedLoanAmount = _encryptionService.encryptData(
      sanitizedLoanAmount,
    );

    // ApplicantModel stores encrypted PAN for secure persistence,
    // but uses raw numeric values for eligibility evaluation.
    // Encrypted income and loan amount are available for secure
    // storage if persisted to disk: encryptedIncome, encryptedLoanAmount.
    final applicant = ApplicantModel(
      fullName: sanitizedName,
      panNumber: encryptedPan,
      monthlyIncome: double.parse(sanitizedIncome),
      requestedLoanAmount: double.parse(sanitizedLoanAmount),
      employmentType: event.employmentType,
      creditHistory: event.creditHistory,
    );

    // Log encrypted values for secure persistence layer
    _lastEncryptedIncome = encryptedIncome;
    _lastEncryptedLoanAmount = encryptedLoanAmount;

    emit(ApplicantValid(applicant: applicant));
  }

  ApplicantModel _buildApplicant({
    required String fullName,
    required String panNumber,
    required String monthlyIncome,
    required String requestedLoanAmount,
    required String employmentType,
    required int creditHistory,
  }) {
    return ApplicantModel(
      fullName: Validators.sanitizeName(Validators.sanitizeInput(fullName)),
      panNumber: Validators.sanitizePan(Validators.sanitizeInput(panNumber)),
      monthlyIncome: double.tryParse(
            Validators.sanitizeNumeric(monthlyIncome),
          ) ??
          0,
      requestedLoanAmount: double.tryParse(
            Validators.sanitizeNumeric(requestedLoanAmount),
          ) ??
          0,
      employmentType: employmentType,
      creditHistory: creditHistory,
    );
  }

  Map<String, String> _validate({
    required String fullName,
    required String panNumber,
    required String monthlyIncome,
    required String requestedLoanAmount,
  }) {
    final errors = <String, String>{};

    final nameError = Validators.validateName(fullName);
    if (nameError != null) errors['fullName'] = nameError;

    final panError = Validators.validatePan(panNumber);
    if (panError != null) errors['panNumber'] = panError;

    final incomeError = Validators.validateIncome(monthlyIncome);
    if (incomeError != null) errors['monthlyIncome'] = incomeError;

    final loanError = Validators.validateLoanAmount(requestedLoanAmount);
    if (loanError != null) errors['requestedLoanAmount'] = loanError;

    return errors;
  }
}
