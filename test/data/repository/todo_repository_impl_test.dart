import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/data/datasources/local_data_source.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';
import 'package:todo_bloc_riverpod/data/repository/todo_repository_impl.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  late TodoRepositoryImpl todoRepositoryImpl;
  late MockTodoLocalDataSource mockTodoLocalDataSource;
  late List<TodoModel> todoModels;
  late List<Todo> todos;
  late TodoModel todoModel;
  late CacheException error;
  late Todo todo;
  late String id;

  setUp(() {
    mockTodoLocalDataSource = MockTodoLocalDataSource();
    todoRepositoryImpl =
        TodoRepositoryImpl(localDataSource: mockTodoLocalDataSource);
    todoModel = TodoModel(id: "1", title: "title", completed: false);
    todoModels = [todoModel];
    todos = todoModels.map((e) => e.toTodo).toList();
    todo = todos.first;
    id = todo.id;
    error = CacheException(message: "error");
  });

  group('Get todos', () {
    test('Should return list of todos when call is successful', () async {
      // Arrange
      when(() => mockTodoLocalDataSource.getTodos())
          .thenAnswer((invocation) async => todoModels);
      // Act
      final result = await todoRepositoryImpl.getTodos();
      // Assert
      expect(result, todos);
      verify(() => mockTodoLocalDataSource.getTodos());
      verify(() => mockTodoLocalDataSource.saveTodos(todoModels: todoModels));
      verifyNoMoreInteractions(mockTodoLocalDataSource);
    });

    test('Should throw a cache error when call is unsuccessful', () async {
      // Arrange
      when(() => mockTodoLocalDataSource.getTodos()).thenThrow(error);
      // Act
      // Assert
      expect(
          () async => todoRepositoryImpl.getTodos(),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoLocalDataSource.getTodos());
      verifyNoMoreInteractions(mockTodoLocalDataSource);
    });
  });

  group('Add todos', () {
    test('Should return list of todos when call is successful', () async {
      // Arrange
      when(() => mockTodoLocalDataSource.addTodo(todoModel: todoModel))
          .thenAnswer((invocation) async => todoModels);
      // Act
      final result = await todoRepositoryImpl.addTodo(todo: todo);
      // Assert
      expect(result, todos);
      verify(() => mockTodoLocalDataSource.addTodo(todoModel: todoModel));
      verifyNoMoreInteractions(mockTodoLocalDataSource);
    });

    test('Should throw a cache error when call is unsuccessful', () async {
      // Arrange
      when(() => mockTodoLocalDataSource.addTodo(todoModel: todoModel))
          .thenThrow(error);
      // Act
      // Assert
      expect(
          () async => todoRepositoryImpl.addTodo(todo: todo),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoLocalDataSource.addTodo(todoModel: todoModel));
      verifyNoMoreInteractions(mockTodoLocalDataSource);
    });
  });

  group('Delete todos', () {
    test('Should return list of todos when call is successful', () async {
      // Arrange
      when(() => mockTodoLocalDataSource.deleteTodo(id: id))
          .thenAnswer((invocation) async => todoModels);
      // Act
      final result = await todoRepositoryImpl.deleteTodo(id: id);
      // Assert
      expect(result, todos);
      verify(() => mockTodoLocalDataSource.deleteTodo(id: id));
      verifyNoMoreInteractions(mockTodoLocalDataSource);
    });

    test('Should throw a cache error when call is unsuccessful', () async {
      // Arrange
      when(() => mockTodoLocalDataSource.deleteTodo(id: id)).thenThrow(error);
      // Act
      // Assert
      expect(
          () async => todoRepositoryImpl.deleteTodo(id: id),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoLocalDataSource.deleteTodo(id: id));
      verifyNoMoreInteractions(mockTodoLocalDataSource);
    });
  });

  group('Toggle todos', () {
    test('Should return list of todos when call is successful', () async {
      // Arrange
      when(() => mockTodoLocalDataSource.toggleTodoAsCompleted(id: id))
          .thenAnswer((invocation) async => todoModels);
      // Act
      final result = await todoRepositoryImpl.toggleTodoAsCompleted(id: id);
      // Assert
      expect(result, todos);
      verify(() => mockTodoLocalDataSource.toggleTodoAsCompleted(id: id));
      verifyNoMoreInteractions(mockTodoLocalDataSource);
    });

    test('Should throw a cache error when call is unsuccessful', () async {
      // Arrange
      when(() => mockTodoLocalDataSource.toggleTodoAsCompleted(id: id))
          .thenThrow(error);
      // Act
      // Assert
      expect(
          () async => todoRepositoryImpl.toggleTodoAsCompleted(id: id),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoLocalDataSource.toggleTodoAsCompleted(id: id));
      verifyNoMoreInteractions(mockTodoLocalDataSource);
    });
  });
}
