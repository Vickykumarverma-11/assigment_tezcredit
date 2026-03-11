import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:assigment_tezcredit/core/utils/emi_calculator.dart';

// ─── Events ───────────────────────────────────────────────

abstract class EmiEvent extends Equatable {
  const EmiEvent();

  @override
  List<Object?> get props => [];
}

class EmiInputChanged extends EmiEvent {
  final double amount;
  final double rate;
  final int tenure;

  const EmiInputChanged({
    required this.amount,
    required this.rate,
    required this.tenure,
  });

  @override
  List<Object?> get props => [amount, rate, tenure];
}

// ─── States ───────────────────────────────────────────────

abstract class EmiState extends Equatable {
  const EmiState();

  @override
  List<Object?> get props => [];
}

class EmiInitial extends EmiState {
  const EmiInitial();
}

class EmiCalculated extends EmiState {
  final double emi;
  final double totalPayment;
  final double totalInterest;

  const EmiCalculated({
    required this.emi,
    required this.totalPayment,
    required this.totalInterest,
  });

  @override
  List<Object?> get props => [emi, totalPayment, totalInterest];
}

// ─── Bloc ─────────────────────────────────────────────────

class EmiBloc extends Bloc<EmiEvent, EmiState> {
  EmiBloc() : super(const EmiInitial()) {
    on<EmiInputChanged>(_onEmiInputChanged);
  }

  void _onEmiInputChanged(
    EmiInputChanged event,
    Emitter<EmiState> emit,
  ) {
    if (event.amount <= 0 || event.rate <= 0 || event.tenure <= 0) {
      emit(const EmiInitial());
      return;
    }

    final result = EmiCalculator.calculate(
      loanAmount: event.amount,
      annualInterestRate: event.rate,
      tenureMonths: event.tenure,
    );

    emit(EmiCalculated(
      emi: result.monthlyEmi,
      totalPayment: result.totalPayment,
      totalInterest: result.totalInterest,
    ));
  }
}
