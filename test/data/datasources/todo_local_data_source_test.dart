import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/data/datasources/local_data_source.dart';
import 'package:todo_bloc_riverpod/data/datasources/todo_hive_helper.dart';
import 'package:todo_bloc_riverpod/data/models/todo_model.dart';

class MockTodoHiveHelper extends Mock implements TodoHiveHelper {}

void main() {
  late TodoLocalDataSourceImpl todoLocalDataSourceImpl;
  late MockTodoHiveHelper mockTodoHiveHelper;
  late List<TodoModel> todoModels;
  late CacheException error;
  late TodoModel todoModel;
  late String id;

  setUp(() {
    mockTodoHiveHelper = MockTodoHiveHelper();
    todoLocalDataSourceImpl =
        TodoLocalDataSourceImpl(hiveHelper: mockTodoHiveHelper);
    todoModels = [TodoModel(id: "1", title: "title", completed: false)];
    error = CacheException(message: 'error');
    todoModel = TodoModel(id: "1", title: "title", completed: false);
    id = "1";
  });

  group('Get Todos', () {
    test('Should return a list of todos when it exists in cache', () async {
      // Arrange
      when(() => mockTodoHiveHelper.getTodos())
          .thenAnswer((invocation) => Future.value(todoModels));
      // Act
      final result = await todoLocalDataSourceImpl.getTodos();
      // Assert
      expect(result, todoModels);
      verify(() => mockTodoHiveHelper.getTodos());
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });

    test('Should throw a cache exception when there is no data in cache',
        () async {
      // Arrange
      when(() => mockTodoHiveHelper.getTodos()).thenThrow(error);
      // Assert
      expect(
          () async => todoLocalDataSourceImpl.getTodos(),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoHiveHelper.getTodos());
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });

  group('Save todos', () {
    test('Should call hive helper to save todos', () async {
      // Arrange
      when(() => mockTodoHiveHelper.saveTodos(todoModels: todoModels))
          .thenAnswer((invocation) => Future.value(true));
      // Act
      await todoLocalDataSourceImpl.saveTodos(todoModels: todoModels);
      // Assert
      verify(() => mockTodoHiveHelper.saveTodos(todoModels: todoModels))
          .called(1);
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });

  group('Add Todo', () {
    test('Should return a list of todos call is successful', () async {
      // Arrange
      when(() => mockTodoHiveHelper.addTodo(todoModel: todoModel))
          .thenAnswer((invocation) => Future.value(todoModels));
      // Act
      final result =
          await todoLocalDataSourceImpl.addTodo(todoModel: todoModel);
      // Assert
      expect(result, todoModels);
      verify(() => mockTodoHiveHelper.addTodo(todoModel: todoModel));
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });

  group('Toggle Todo', () {
    test('Should return a list of todos toggle todo is succesfull', () async {
      // Arrange
      when(() => mockTodoHiveHelper.toggleTodoAsCompleted(id: id))
          .thenAnswer((invocation) => Future.value(todoModels));
      // Act
      final result =
          await todoLocalDataSourceImpl.toggleTodoAsCompleted(id: id);
      // Assert
      expect(result, todoModels);
      verify(() => mockTodoHiveHelper.toggleTodoAsCompleted(id: id));
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });

    test('Should throw a cache exception when toggle todo is unsuccessfull',
        () async {
      // Arrange
      when(() => mockTodoHiveHelper.toggleTodoAsCompleted(id: id))
          .thenThrow(error);
      // Assert
      expect(
          () async => todoLocalDataSourceImpl.toggleTodoAsCompleted(id: id),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoHiveHelper.toggleTodoAsCompleted(id: id));
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });

  group('Delete Todo', () {
    test('Should return a list of todos delete todo is succesfull', () async {
      // Arrange
      when(() => mockTodoHiveHelper.deleteTodo(id: id))
          .thenAnswer((invocation) => Future.value(todoModels));
      // Act
      final result = await todoLocalDataSourceImpl.deleteTodo(id: id);
      // Assert
      expect(result, todoModels);
      verify(() => mockTodoHiveHelper.deleteTodo(id: id));
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });

    test('Should throw a cache exception when delete todo is unsuccessfull',
        () async {
      // Arrange
      when(() => mockTodoHiveHelper.deleteTodo(id: id)).thenThrow(error);
      // Assert
      expect(
          () async => todoLocalDataSourceImpl.deleteTodo(id: id),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoHiveHelper.deleteTodo(id: id));
      verifyNoMoreInteractions(mockTodoHiveHelper);
    });
  });
}
