import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<List<Todo>> addTodo({required Todo todo});
  Future<List<Todo>> toggleTodoAsCompleted({required String id});
  Future<List<Todo>> deleteTodo({required String id});
}
