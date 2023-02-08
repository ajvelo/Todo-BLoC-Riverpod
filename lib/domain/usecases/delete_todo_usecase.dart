import '../entities/todo.dart';
import '../repository/repository.dart';

class DeleteTodoUsecase {
  final TodoRepository repository;

  DeleteTodoUsecase({required this.repository});

  Future<List<Todo>> execute({required String id}) async {
    return repository.deleteTodo(id: id);
  }
}
