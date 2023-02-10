import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/repository/repository.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late GetTodoUsecase getTodoUsecase;
  late MockTodoRepository mockTodoRepository;
  late List<Todo> todos;
  late CacheException error;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    getTodoUsecase = GetTodoUsecase(repository: mockTodoRepository);
    todos = [Todo(id: '1', title: 'title', completed: false)];
    error = CacheException(message: 'error');
  });

  group('Get Todos from repository', () {
    test('Should return entity from repository when call is succesfull',
        () async {
      // Arrange
      when(() => mockTodoRepository.getTodos())
          .thenAnswer((invocation) async => todos);
      // Act
      final result = await getTodoUsecase.execute();
      // Assert
      expect(result, todos);
      verify(() => mockTodoRepository.getTodos());
      verifyNoMoreInteractions(mockTodoRepository);
    });

    test('Should throw error when call to repository is unsuccessfull',
        () async {
      // Arrange
      when(() => mockTodoRepository.getTodos()).thenThrow(error);
      // Act
      // Assert
      expect(
          () => getTodoUsecase.execute(),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoRepository.getTodos());
      verifyNoMoreInteractions(mockTodoRepository);
    });
  });
}
