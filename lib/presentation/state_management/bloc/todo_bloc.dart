import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/bloc/todo_event.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/todo_state.dart';

import '../../../core/exceptions.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodoUsecase getTodoUsecase;
  final AddTodoUsecase addTodoUsecase;
  final ToggleTodoUsecase toggleTodoUsecase;
  final DeleteTodoUsecase deleteTodoUsecase;
  TodoBloc(
      {required this.getTodoUsecase,
      required this.addTodoUsecase,
      required this.toggleTodoUsecase,
      required this.deleteTodoUsecase})
      : super(TodoInitial()) {
    on<GetTodoEvent>(_getTodoRequested);
    on<AddTodoEvent>(_addTodoRequested);
    on<ToggleTodoEvent>(_toggleTodoRequested);
    on<DeleteTodoEvent>(_deleteTodoRequested);
  }

  _getTodoRequested(GetTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await getTodoUsecase.execute();
      emit(TodosLoaded(todos: todos));
    } on CacheException catch (e) {
      emit(TodosLoadedWithError(message: e.message));
    } catch (e) {
      emit(TodosLoadedWithError(message: e.toString()));
    }
  }

  _addTodoRequested(AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await addTodoUsecase.execute(todo: event.todo);
      emit(TodosLoaded(todos: todos));
    } on CacheException catch (e) {
      emit(TodosLoadedWithError(message: e.message));
    } catch (e) {
      emit(TodosLoadedWithError(message: e.toString()));
    }
  }

  _toggleTodoRequested(ToggleTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await toggleTodoUsecase.execute(id: event.id);
      emit(TodosLoaded(todos: todos));
    } on CacheException catch (e) {
      emit(TodosLoadedWithError(message: e.message));
    } catch (e) {
      emit(TodosLoadedWithError(message: e.toString()));
    }
  }

  _deleteTodoRequested(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await deleteTodoUsecase.execute(id: event.id);
      emit(TodosLoaded(todos: todos));
    } on CacheException catch (e) {
      emit(TodosLoadedWithError(message: e.message));
    } catch (e) {
      emit(TodosLoadedWithError(message: e.toString()));
    }
  }
}
