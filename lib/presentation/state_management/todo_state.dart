import '../domain/entities/todo.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;

  TodosLoaded({required this.todos});
}

class TodosLoadedWithError extends TodoState {
  final String message;

  TodosLoadedWithError({required this.message});
}
