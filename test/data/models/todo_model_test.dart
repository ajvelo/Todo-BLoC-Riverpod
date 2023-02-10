import 'package:flutter_test/flutter_test.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';

void main() {
  final todoModel = TodoModel(id: "1", title: "title", completed: false);

  group('Model converts to entity', () {
    test('Should successfully concert to a Todo entity', () {
      // Arrange
      final todo = todoModel.toTodo;
      // Assert
      expect(todo, isA<Todo>());
      expect(todoModel.id, todo.id);
      expect(todoModel.title, todo.title);
      expect(todoModel.completed, todo.completed);
    });
  });
}
