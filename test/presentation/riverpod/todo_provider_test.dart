import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/riverpod/todo_provider.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/todo_state.dart';

class MockGetTodoUsecase extends Mock implements GetTodoUsecase {}

class MockAddTodoUsecase extends Mock implements AddTodoUsecase {}

class MockDeleteTodoUsecase extends Mock implements DeleteTodoUsecase {}

class MockToggleTodoUsecase extends Mock implements ToggleTodoUsecase {}

void main() {
  late MockGetTodoUsecase mockGetTodoUsecase;
  late MockAddTodoUsecase mockAddTodoUsecase;
  late MockDeleteTodoUsecase mockDeleteTodoUsecase;
  late MockToggleTodoUsecase mockToggleTodoUsecase;
  late NotifierProvider<TodoNotifier, TodoState> todoProvider;
  late ProviderContainer container;
  late Todo todo;
  late List<Todo> todos;
  late String id;
  late CacheException error;

  setUp(() {
    container = ProviderContainer();
    mockGetTodoUsecase = MockGetTodoUsecase();
    mockAddTodoUsecase = MockAddTodoUsecase();
    mockToggleTodoUsecase = MockToggleTodoUsecase();
    mockDeleteTodoUsecase = MockDeleteTodoUsecase();
    todo = Todo(id: "1", title: "title", completed: false);
    todos = [todo];
    id = "1";
    error = CacheException(message: 'error');

    todoProvider = NotifierProvider<TodoNotifier, TodoState>(
      () {
        return TodoNotifier(
            getTodoUsecase: mockGetTodoUsecase,
            addTodoUsecase: mockAddTodoUsecase,
            deleteTodoUsecase: mockDeleteTodoUsecase,
            toggleTodoUsecase: mockToggleTodoUsecase);
      },
    );
  });

  group('Initial State', () {
    test('Initial state should be Todo Initial', () {
      // Arrange
      final state = container.read(todoProvider);
      // Assert
      expect(state, equals(TodoInitial()));
    });
  });

  group('Get todos', () {
    test('Provider calls usecase', () async {
      // Arrange
      when(() => mockGetTodoUsecase.execute())
          .thenAnswer((invocation) async => todos);
      // Act
      container.read(todoProvider.notifier).getTodos();
      await untilCalled(() => mockGetTodoUsecase.execute());
      // Assert
      verify(() => mockGetTodoUsecase.execute());
      verifyNoMoreInteractions(mockGetTodoUsecase);
    });

    test(
        'Provider should emit correct order of states when usecase is called with success',
        () async {
      // Arrange
      final firstState = container.read(todoProvider);
      var orderOfStates = [firstState];
      container.listen(
        todoProvider,
        (previous, next) {
          orderOfStates.add(next);
        },
      );
      when(() => mockGetTodoUsecase.execute())
          .thenAnswer((invocation) async => todos);
      // Act
      container.read(todoProvider.notifier).getTodos();
      await untilCalled(() => mockGetTodoUsecase.execute());
      // Assert
      expect(orderOfStates,
          [TodoInitial(), TodoLoading(), TodosLoaded(todos: todos)]);
      verify(() => mockGetTodoUsecase.execute());
      verifyNoMoreInteractions(mockGetTodoUsecase);
    });

    test(
        'Provider should emit correct order of states when usecase is called with error',
        () async {
      // Arrange
      final firstState = container.read(todoProvider);
      var orderOfStates = [firstState];
      container.listen(
        todoProvider,
        (previous, next) {
          orderOfStates.add(next);
        },
      );
      when(() => mockGetTodoUsecase.execute()).thenThrow(error);
      // Act
      container.read(todoProvider.notifier).getTodos();
      await untilCalled(() => mockGetTodoUsecase.execute());
      // Assert
      expect(orderOfStates, [
        TodoInitial(),
        TodoLoading(),
        TodosLoadedWithError(message: error.message)
      ]);
      verify(() => mockGetTodoUsecase.execute());
      verifyNoMoreInteractions(mockGetTodoUsecase);
    });
  });

  group('Add todos', () {
    test('Provider calls usecase', () async {
      // Arrange
      when(() => mockAddTodoUsecase.execute(todo: todo))
          .thenAnswer((invocation) async => todos);
      // Act
      container.read(todoProvider.notifier).addTodos(todo: todo);
      await untilCalled(() => mockAddTodoUsecase.execute(todo: todo));
      // Assert
      verify(() => mockAddTodoUsecase.execute(todo: todo));
      verifyNoMoreInteractions(mockAddTodoUsecase);
    });

    test(
        'Provider should emit correct order of states when usecase is called with success',
        () async {
      // Arrange
      final firstState = container.read(todoProvider);
      var orderOfStates = [firstState];
      container.listen(
        todoProvider,
        (previous, next) {
          orderOfStates.add(next);
        },
      );
      when(() => mockAddTodoUsecase.execute(todo: todo))
          .thenAnswer((invocation) async => todos);
      // Act
      container.read(todoProvider.notifier).addTodos(todo: todo);
      await untilCalled(() => mockAddTodoUsecase.execute(todo: todo));
      // Assert
      expect(orderOfStates,
          [TodoInitial(), TodoLoading(), TodosLoaded(todos: todos)]);
      verify(() => mockAddTodoUsecase.execute(todo: todo));
      verifyNoMoreInteractions(mockAddTodoUsecase);
    });

    test(
        'Provider should emit correct order of states when usecase is called with error',
        () async {
      // Arrange
      final firstState = container.read(todoProvider);
      var orderOfStates = [firstState];
      container.listen(
        todoProvider,
        (previous, next) {
          orderOfStates.add(next);
        },
      );
      when(() => mockAddTodoUsecase.execute(todo: todo)).thenThrow(error);
      // Act
      container.read(todoProvider.notifier).addTodos(todo: todo);
      await untilCalled(() => mockAddTodoUsecase.execute(todo: todo));
      // Assert
      expect(orderOfStates, [
        TodoInitial(),
        TodoLoading(),
        TodosLoadedWithError(message: error.message)
      ]);
      verify(() => mockAddTodoUsecase.execute(todo: todo));
      verifyNoMoreInteractions(mockAddTodoUsecase);
    });
  });

  group('Delete todos', () {
    test('Provider calls usecase', () async {
      // Arrange
      when(() => mockDeleteTodoUsecase.execute(id: id))
          .thenAnswer((invocation) async => todos);
      // Act
      container.read(todoProvider.notifier).deleteTodo(id: id);
      await untilCalled(() => mockDeleteTodoUsecase.execute(id: id));
      // Assert
      verify(() => mockDeleteTodoUsecase.execute(id: id));
      verifyNoMoreInteractions(mockDeleteTodoUsecase);
    });

    test(
        'Provider should emit correct order of states when usecase is called with success',
        () async {
      // Arrange
      final firstState = container.read(todoProvider);
      var orderOfStates = [firstState];
      container.listen(
        todoProvider,
        (previous, next) {
          orderOfStates.add(next);
        },
      );
      when(() => mockDeleteTodoUsecase.execute(id: id))
          .thenAnswer((invocation) async => todos);
      // Act
      container.read(todoProvider.notifier).deleteTodo(id: id);
      await untilCalled(() => mockDeleteTodoUsecase.execute(id: id));
      // Assert
      expect(orderOfStates,
          [TodoInitial(), TodoLoading(), TodosLoaded(todos: todos)]);
      verify(() => mockDeleteTodoUsecase.execute(id: id));
      verifyNoMoreInteractions(mockDeleteTodoUsecase);
    });

    test(
        'Provider should emit correct order of states when usecase is called with error',
        () async {
      // Arrange
      final firstState = container.read(todoProvider);
      var orderOfStates = [firstState];
      container.listen(
        todoProvider,
        (previous, next) {
          orderOfStates.add(next);
        },
      );
      when(() => mockDeleteTodoUsecase.execute(id: id)).thenThrow(error);
      // Act
      container.read(todoProvider.notifier).deleteTodo(id: id);
      await untilCalled(() => mockDeleteTodoUsecase.execute(id: id));
      // Assert
      expect(orderOfStates, [
        TodoInitial(),
        TodoLoading(),
        TodosLoadedWithError(message: error.message)
      ]);
      verify(() => mockDeleteTodoUsecase.execute(id: id));
      verifyNoMoreInteractions(mockDeleteTodoUsecase);
    });
  });

  group('Toggle todos', () {
    test('Provider calls usecase', () async {
      // Arrange
      when(() => mockToggleTodoUsecase.execute(id: id))
          .thenAnswer((invocation) async => todos);
      // Act
      container.read(todoProvider.notifier).toggleTodo(id: id);
      await untilCalled(() => mockToggleTodoUsecase.execute(id: id));
      // Assert
      verify(() => mockToggleTodoUsecase.execute(id: id));
      verifyNoMoreInteractions(mockToggleTodoUsecase);
    });

    test(
        'Provider should emit correct order of states when usecase is called with success',
        () async {
      // Arrange
      final firstState = container.read(todoProvider);
      var orderOfStates = [firstState];
      container.listen(
        todoProvider,
        (previous, next) {
          orderOfStates.add(next);
        },
      );
      when(() => mockToggleTodoUsecase.execute(id: id))
          .thenAnswer((invocation) async => todos);
      // Act
      container.read(todoProvider.notifier).toggleTodo(id: id);
      await untilCalled(() => mockToggleTodoUsecase.execute(id: id));
      // Assert
      expect(orderOfStates,
          [TodoInitial(), TodoLoading(), TodosLoaded(todos: todos)]);
      verify(() => mockToggleTodoUsecase.execute(id: id));
      verifyNoMoreInteractions(mockToggleTodoUsecase);
    });

    test(
        'Provider should emit correct order of states when usecase is called with error',
        () async {
      // Arrange
      final firstState = container.read(todoProvider);
      var orderOfStates = [firstState];
      container.listen(
        todoProvider,
        (previous, next) {
          orderOfStates.add(next);
        },
      );
      when(() => mockToggleTodoUsecase.execute(id: id)).thenThrow(error);
      // Act
      container.read(todoProvider.notifier).toggleTodo(id: id);
      await untilCalled(() => mockToggleTodoUsecase.execute(id: id));
      // Assert
      expect(orderOfStates, [
        TodoInitial(),
        TodoLoading(),
        TodosLoadedWithError(message: error.message)
      ]);
      verify(() => mockToggleTodoUsecase.execute(id: id));
      verifyNoMoreInteractions(mockToggleTodoUsecase);
    });
  });
}
