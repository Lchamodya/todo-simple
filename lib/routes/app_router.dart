import 'package:flutter/material.dart';
import 'package:todo_simple/auth_screen.dart';
import 'package:todo_simple/routes/pages.dart';
import 'package:todo_simple/splash_screen.dart';
import 'package:todo_simple/tasks/data/local/model/task_model.dart';
import 'package:todo_simple/tasks/presentation/pages/new_task_screen.dart';
import 'package:todo_simple/tasks/presentation/pages/tasks_screen.dart';
import 'package:todo_simple/tasks/presentation/pages/update_task_screen.dart';
import 'package:todo_simple/page_not_found.dart';
import 'package:todo_simple/auth_guard.dart';

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  final args = routeSettings.arguments;

  switch (routeSettings.name) {
    case Pages.auth:
      return MaterialPageRoute(
        builder: (_) => const AuthScreen(),
      );
    case Pages.initial:
      return MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      );
    case Pages.home:
      return AuthGuard.guard(
        routeSettings: routeSettings,
        builder: (_) => const TasksScreen(),
      );
    case Pages.createNewTask:
      return AuthGuard.guard(
        routeSettings: routeSettings,
        builder: (_) => const NewTaskScreen(),
      );
    case Pages.updateTask:
      if (args is TaskModel) {
        return AuthGuard.guard(
          routeSettings: routeSettings,
          builder: (_) => UpdateTaskScreen(taskModel: args),
        );
      } else {
        return _errorRoute(
          'Invalid arguments for UpdateTask. Expected a TaskModel.',
        );
      }
    default:
      return _errorRoute('Page not found');
  }
}

Route<dynamic> _errorRoute(String errorMessage) {
  return MaterialPageRoute(
    builder: (_) => PageNotFound(
      errorMessage: errorMessage,
    ),
  );
}
