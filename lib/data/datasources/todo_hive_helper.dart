import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/data/datasources/local_data_source.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';

class TodoHiveHelper implements TodoLocalDataSource {
  @override
  Future<List<TodoModel>> addTodo({required TodoModel todoModel}) async {
    final box = await Hive.openBox<TodoModel>('todos');
    box.put(todoModel.id, todoModel);
    return getTodos();
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    final box = await Hive.openBox<TodoModel>('todos');
    final todos = box.values.toList().cast<TodoModel>();
    return todos;
  }

  @override
  Future<List<TodoModel>> toggleTodoAsCompleted({required String id}) async {
    final box = await Hive.openBox<TodoModel>('todos');
    final model = box.get(id);
    if (model == null) {
      throw CacheException(message: 'Item can not be fetched');
    } else {
      model.completed = !model.completed;
      box.put(model.id, model);
      return getTodos();
    }
  }

  @override
  saveTodos({required List<TodoModel> todoModels}) async {
    final box = await Hive.openBox<TodoModel>('todos');
    await box.clear();
    for (var todoModel in todoModels) {
      box.put(todoModel.id, todoModel);
    }
  }

  @override
  Future<List<TodoModel>> deleteTodo({required String id}) async {
    final box = await Hive.openBox<TodoModel>('todos');
    final model = box.get(id);
    if (model == null) {
      throw CacheException(message: 'Item can not be fetched');
    } else {
      box.delete(id);
      return getTodos();
    }
  }
}
