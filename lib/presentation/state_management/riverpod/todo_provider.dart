import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_bloc_riverpod/data/datasources/local_data_source.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo_hive_helper.dart';
import 'package:todo_bloc_riverpod/data/repository/todo_repository_impl.dart';
import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/todo_state.dart';

import '../../../domain/entities/todo.dart';

final todoProvider = NotifierProvider<TodoNotifier, TodoState>(
  () {
    final repository = TodoRepositoryImpl(
        localDataSource: TodoLocalDataSourceImpl(hiveHelper: TodoHiveHelper()));
    return TodoNotifier(
        getTodoUsecase: GetTodoUsecase(repository: repository),
        addTodoUsecase: AddTodoUsecase(repository: repository),
        deleteTodoUsecase: DeleteTodoUsecase(repository: repository),
        toggleTodoUsecase: ToggleTodoUsecase(repository: repository));
  },
);

class TodoNotifier extends Notifier<TodoState> {
  final GetTodoUsecase getTodoUsecase;
  final AddTodoUsecase addTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;
  final ToggleTodoUsecase toggleTodoUsecase;

  TodoNotifier(
      {required this.getTodoUsecase,
      required this.addTodoUsecase,
      required this.deleteTodoUsecase,
      required this.toggleTodoUsecase})
      : super();
  @override
  TodoState build() {
    return TodoInitial();
  }

  getTodos() async {
    state = TodoLoading();
    try {
      final todos = await getTodoUsecase.execute();
      state = TodosLoaded(todos: todos);
    } on Exception catch (e) {
      state = TodosLoadedWithError(message: e.toString());
    } catch (e) {
      state = TodosLoadedWithError(message: e.toString());
    }
  }

  addTodos({required Todo todo}) async {
    state = TodoLoading();
    try {
      final todos = await addTodoUsecase.execute(todo: todo);
      state = TodosLoaded(todos: todos);
    } on Exception catch (e) {
      state = TodosLoadedWithError(message: e.toString());
    } catch (e) {
      state = TodosLoadedWithError(message: e.toString());
    }
  }

  toggleTodo({required String id}) async {
    state = TodoLoading();
    try {
      final todos = await toggleTodoUsecase.execute(id: id);
      state = TodosLoaded(todos: todos);
    } on Exception catch (e) {
      state = TodosLoadedWithError(message: e.toString());
    } catch (e) {
      state = TodosLoadedWithError(message: e.toString());
    }
  }

  deleteTodo({required String id}) async {
    state = TodoLoading();
    try {
      final todos = await deleteTodoUsecase.execute(id: id);
      state = TodosLoaded(todos: todos);
    } on Exception catch (e) {
      state = TodosLoadedWithError(message: e.toString());
    } catch (e) {
      state = TodosLoadedWithError(message: e.toString());
    }
  }
}
