import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/repository/repository.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late DeleteTodoUsecase deleteTodoUsecase;
  late MockTodoRepository mockTodoRepository;
  late String id;
  late List<Todo> todos;
  late CacheException error;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    deleteTodoUsecase = DeleteTodoUsecase(repository: mockTodoRepository);
    id = "1";
    todos = [Todo(id: '1', title: 'title', completed: false)];
    error = CacheException(message: 'error');
  });

  group('Get Todos from repository', () {
    test('Should return entity from repository when call is succesfull',
        () async {
      // Arrange
      when(() => mockTodoRepository.deleteTodo(id: id))
          .thenAnswer((invocation) async => todos);
      // Act
      final result = await deleteTodoUsecase.execute(id: id);
      // Assert
      expect(result, todos);
      verify(() => mockTodoRepository.deleteTodo(id: id));
      verifyNoMoreInteractions(mockTodoRepository);
    });

    test('Should throw error when call to repository is unsuccessfull',
        () async {
      // Arrange
      when(() => mockTodoRepository.deleteTodo(id: id)).thenThrow(error);
      // Act
      // Assert
      expect(
          () => deleteTodoUsecase.execute(id: id),
          throwsA(predicate(
              (p0) => p0 is CacheException && p0.message == error.message)));
      verify(() => mockTodoRepository.deleteTodo(id: id));
      verifyNoMoreInteractions(mockTodoRepository);
    });
  });
}
