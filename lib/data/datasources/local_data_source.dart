import 'package:todo_bloc_riverpod/data/datasources/todo_hive_helper.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';

abstract class TodoLocalDataSource {
  saveTodos({required List<TodoModel> todoModels});
  Future<List<TodoModel>> getTodos();
  Future<List<TodoModel>> addTodo({required TodoModel todoModel});
  Future<List<TodoModel>> toggleTodoAsCompleted({required String id});
  Future<List<TodoModel>> deleteTodo({required String id});
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final TodoHiveHelper hiveHelper;

  TodoLocalDataSourceImpl({required this.hiveHelper});
  @override
  Future<List<TodoModel>> addTodo({required TodoModel todoModel}) async {
    return await hiveHelper.addTodo(todoModel: todoModel);
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    return await hiveHelper.getTodos();
  }

  @override
  saveTodos({required List<TodoModel> todoModels}) async {
    await hiveHelper.saveTodos(todoModels: todoModels);
  }

  @override
  Future<List<TodoModel>> toggleTodoAsCompleted({required String id}) async {
    return await hiveHelper.toggleTodoAsCompleted(id: id);
  }

  @override
  Future<List<TodoModel>> deleteTodo({required String id}) async {
    return await hiveHelper.deleteTodo(id: id);
  }
}
