import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_simple/routes/app_router.dart';
import 'package:todo_simple/bloc_state_observer.dart';
import 'package:todo_simple/routes/pages.dart';
import 'package:todo_simple/tasks/data/local/data_sources/tasks_data_provider.dart';
import 'package:todo_simple/tasks/data/repository/task_repository.dart';
import 'package:todo_simple/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:todo_simple/utils/color_palette.dart';
import 'auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocStateObserver();
  final preferences = await SharedPreferences.getInstance();
  runApp(MyApp(preferences: preferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({Key? key, required this.preferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TaskRepository(
        taskDataProvider: TaskDataProvider(preferences),
      ),
      child: BlocProvider(
        create: (context) => TasksBloc(context.read<TaskRepository>()),
        child: MaterialApp(
          title: 'Task Manager',
          debugShowCheckedModeBanner: false,
          initialRoute: Pages.auth, // Start with authentication
          onGenerateRoute: onGenerateRoute,
          theme: ThemeData(
            fontFamily: 'Sora',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.transparent,
            colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
