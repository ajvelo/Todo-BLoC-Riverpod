import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  @override
  List<Object?> get props => [id, title, completed];
}
