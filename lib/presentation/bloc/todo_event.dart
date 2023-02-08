import 'package:todo_bloc_riverpod/domain/entities/todo.dart';

abstract class TodoEvent {}

class GetTodoEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;

  AddTodoEvent({required this.todo});
}

class ToggleTodoEvent extends TodoEvent {
  final String id;

  ToggleTodoEvent({required this.id});
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  DeleteTodoEvent({required this.id});
}
