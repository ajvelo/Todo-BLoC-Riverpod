import '../entities/todo.dart';
import '../repository/repository.dart';

class ToggleTodoUsecase {
  final TodoRepository repository;

  ToggleTodoUsecase({required this.repository});

  Future<List<Todo>> execute({required String id}) async {
    return repository.toggleTodoAsCompleted(id: id);
  }
}
