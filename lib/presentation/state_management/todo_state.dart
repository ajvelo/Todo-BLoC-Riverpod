import 'package:equatable/equatable.dart';

import '../../domain/entities/todo.dart';

abstract class TodoState extends Equatable {}

class TodoInitial extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoLoading extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodosLoaded extends TodoState {
  final List<Todo> todos;

  TodosLoaded({required this.todos});
  @override
  List<Object?> get props => [todos];
}

class TodosLoadedWithError extends TodoState {
  final String message;

  TodosLoadedWithError({required this.message});
  @override
  List<Object?> get props => [message];
}
