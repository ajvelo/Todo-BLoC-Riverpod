import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_bloc_riverpod/data/datasources/local_data_source.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo_hive_helper.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';
import 'package:todo_bloc_riverpod/data/repository/todo_repository_impl.dart';
import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/bloc/todo_bloc.dart';
import 'package:todo_bloc_riverpod/presentation/pages/home_page_bloc.dart';
import 'package:todo_bloc_riverpod/presentation/pages/home_page_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = TodoRepositoryImpl(
            localDataSource:
                TodoLocalDataSourceImpl(hiveHelper: TodoHiveHelper()));
        return TodoBloc(
            getTodoUsecase: GetTodoUsecase(repository: repository),
            addTodoUsecase: AddTodoUsecase(repository: repository),
            toggleTodoUsecase: ToggleTodoUsecase(repository: repository),
            deleteTodoUsecase: DeleteTodoUsecase(repository: repository));
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // To use the BLoC implementation uncomment the line below and comment the one below that.
        // home: const HomePageBloc(),
        home: const HomePageRiverpod(),
      ),
    );
  }
}
