import '../entities/todo.dart';
import '../repository/repository.dart';

class AddTodoUsecase {
  final TodoRepository repository;

  AddTodoUsecase({required this.repository});

  Future<List<Todo>> execute({required Todo todo}) async {
    return repository.addTodo(todo: todo);
  }
}
