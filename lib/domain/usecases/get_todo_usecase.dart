import 'package:todo_bloc_riverpod/domain/repository/repository.dart';

import '../entities/todo.dart';

class GetTodoUsecase {
  final TodoRepository repository;

  GetTodoUsecase({required this.repository});

  Future<List<Todo>> execute() async {
    return repository.getTodos();
  }
}
