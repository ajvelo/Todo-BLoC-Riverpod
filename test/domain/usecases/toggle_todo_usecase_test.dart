import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/repository/repository.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late ToggleTodoUsecase toggleTodoUsecase;
  late MockTodoRepository mockTodoRepository;
  late String id;
  late List<Todo> todos;
  late CacheException error;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    toggleTodoUsecase = ToggleTodoUsecase(repository: mockTodoRepository);
    id = "1";
    todos = [Todo(id: '1', title: 'title', completed: false)];
    error = CacheException(message: 'error');
  });

  group('Get Todos from repository', () {
    test('Should return entity from repository when call is succesfull',
        () async {
      // Arrange
      when(() => mockTodoRepository.toggleTodoAsCompleted(id: id))
          .thenAnswer((invocation) async => todos);
      // Act
      final result = await toggleTodoUsecase.execute(id: id);
      // Assert
      expect(result, todos);
      verify(() => mockTodoRepository.toggleTodoAsCompleted(id: id));
      verifyNoMoreInteractions(mockTodoRepository);
    });

    test('Should throw error when call to repository is unsuccessfull',
        () async {
      // Arrange
      when(() => mockTodoRepository.toggleTodoAsCompleted(id: id))
          .thenThrow(error);
      // Act
      // Assert
      expect(
          () => toggleTodoUsecase.execute(id: id),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoRepository.toggleTodoAsCompleted(id: id));
      verifyNoMoreInteractions(mockTodoRepository);
    });
  });
}
