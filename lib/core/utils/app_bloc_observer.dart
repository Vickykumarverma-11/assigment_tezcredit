import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    developer.log(
      '${bloc.runtimeType}: ${transition.event.runtimeType} → '
      '${transition.nextState.runtimeType}',
      name: 'Bloc',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    developer.log(
      '${bloc.runtimeType} error: $error',
      name: 'Bloc',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
