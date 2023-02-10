import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/repository/repository.dart';
import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late AddTodoUsecase addTodoUsecase;
  late MockTodoRepository mockTodoRepository;
  late Todo todo;
  late List<Todo> todos;
  late CacheException error;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    addTodoUsecase = AddTodoUsecase(repository: mockTodoRepository);
    todo = Todo(id: '1', title: 'title', completed: false);
    todos = [todo];
    error = CacheException(message: 'error');
  });

  group('Get Todos from repository', () {
    test('Should return entity from repository when call is succesfull',
        () async {
      // Arrange
      when(() => mockTodoRepository.addTodo(todo: todo))
          .thenAnswer((invocation) async => todos);
      // Act
      final result = await addTodoUsecase.execute(todo: todo);
      // Assert
      expect(result, todos);
      verify(() => mockTodoRepository.addTodo(todo: todo));
      verifyNoMoreInteractions(mockTodoRepository);
    });

    test('Should throw error when call to repository is unsuccessfull',
        () async {
      // Arrange
      when(() => mockTodoRepository.addTodo(todo: todo)).thenThrow(error);
      // Act
      // Assert
      expect(
          () => addTodoUsecase.execute(todo: todo),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoRepository.addTodo(todo: todo));
      verifyNoMoreInteractions(mockTodoRepository);
    });
  });
}
