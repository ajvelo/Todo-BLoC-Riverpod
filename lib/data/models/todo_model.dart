import 'package:hive/hive.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  bool completed;

  TodoModel({required this.id, required this.title, required this.completed});
}

extension TodoModelExtension on TodoModel {
  Todo get toTodo => Todo(id: id, title: title, completed: completed);
}
