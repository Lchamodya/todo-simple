import 'package:flutter/material.dart';
import 'auth_screen.dart';

class AuthGuard {
  static bool isAuthenticated = false; // Track authentication state

  static Route<dynamic> guard({
    required RouteSettings routeSettings,
    required WidgetBuilder builder,
  }) {
    if (isAuthenticated) {
      return MaterialPageRoute(
        builder: builder,
        settings: routeSettings,
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => const AuthScreen(),
        settings: routeSettings,
      );
    }
  }
}
