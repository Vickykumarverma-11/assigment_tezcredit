import 'package:assigment_tezcredit/presentation/bloc/emi_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmiBloc', () {
    blocTest<EmiBloc, EmiState>(
      'emits [EmiCalculated] when valid inputs provided',
      build: () => EmiBloc(),
      act: (bloc) => bloc.add(const EmiInputChanged(
        amount: 100000,
        rate: 12,
        tenure: 12,
      )),
      expect: () => [
        const EmiCalculated(
          emi: 8884.88,
          totalPayment: 106618.55,
          totalInterest: 6618.55,
        ),
      ],
    );

    blocTest<EmiBloc, EmiState>(
      'emits [EmiInitial] when amount is zero',
      build: () => EmiBloc(),
      act: (bloc) => bloc.add(const EmiInputChanged(
        amount: 0,
        rate: 12,
        tenure: 12,
      )),
      expect: () => [const EmiInitial()],
    );

    blocTest<EmiBloc, EmiState>(
      'emits [EmiInitial] when rate is zero',
      build: () => EmiBloc(),
      act: (bloc) => bloc.add(const EmiInputChanged(
        amount: 100000,
        rate: 0,
        tenure: 12,
      )),
      expect: () => [const EmiInitial()],
    );

    blocTest<EmiBloc, EmiState>(
      'emits [EmiInitial] when tenure is zero',
      build: () => EmiBloc(),
      act: (bloc) => bloc.add(const EmiInputChanged(
        amount: 100000,
        rate: 12,
        tenure: 0,
      )),
      expect: () => [const EmiInitial()],
    );

    blocTest<EmiBloc, EmiState>(
      'emits [EmiInitial] when negative amount',
      build: () => EmiBloc(),
      act: (bloc) => bloc.add(const EmiInputChanged(
        amount: -50000,
        rate: 12,
        tenure: 12,
      )),
      expect: () => [const EmiInitial()],
    );

    blocTest<EmiBloc, EmiState>(
      'emits updated EmiCalculated on consecutive inputs',
      build: () => EmiBloc(),
      act: (bloc) {
        bloc.add(const EmiInputChanged(amount: 100000, rate: 12, tenure: 12));
        bloc.add(const EmiInputChanged(amount: 200000, rate: 10, tenure: 24));
      },
      expect: () => [
        const EmiCalculated(
          emi: 8884.88,
          totalPayment: 106618.55,
          totalInterest: 6618.55,
        ),
        const EmiCalculated(
          emi: 9228.99,
          totalPayment: 221495.65,
          totalInterest: 21495.65,
        ),
      ],
    );

    test('initial state is EmiInitial', () {
      expect(EmiBloc().state, const EmiInitial());
    });
  });
}
