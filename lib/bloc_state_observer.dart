import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocStateObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    if (kDebugMode) {
      print('Bloc Created: ${bloc.runtimeType}');
    }
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      print('Bloc Event: ${bloc.runtimeType}, Event: $event');
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      print('Bloc Transition: ${bloc.runtimeType}, Transition: $transition');
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('Bloc Error: ${bloc.runtimeType}, Error: $error, StackTrace: $stackTrace');
    }
    super.onError(bloc, error, stackTrace);
  }
}
