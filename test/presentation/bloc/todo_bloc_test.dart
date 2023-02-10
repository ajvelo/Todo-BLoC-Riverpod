import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc_riverpod/core/exceptions.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/domain/usecases/add_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/delete_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/get_todo_usecase.dart';
import 'package:todo_bloc_riverpod/domain/usecases/toggle_todo_usecase.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/bloc/todo_bloc.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/bloc/todo_event.dart';
import 'package:todo_bloc_riverpod/presentation/state_management/todo_state.dart';

class MockGetTodoUsecase extends Mock implements GetTodoUsecase {}

class MockAddTodoUsecase extends Mock implements AddTodoUsecase {}

class MockToggleTodoUsecase extends Mock implements ToggleTodoUsecase {}

class MockDeleteTodoUsecase extends Mock implements DeleteTodoUsecase {}

void main() {
  late List<Todo> todos;
  late String id;
  late Todo todo;
  late CacheException error;
  late MockAddTodoUsecase mockAddTodoUsecase;
  late MockDeleteTodoUsecase mockDeleteTodoUsecase;
  late MockGetTodoUsecase mockGetTodoUsecase;
  late MockToggleTodoUsecase mockToggleTodoUsecase;
  late TodoBloc todoBloc;

  setUp(() {
    todos = [Todo(id: "1", title: "title", completed: false)];
    id = "1";
    todo = todos.first;
    error = CacheException(message: "error");
    mockGetTodoUsecase = MockGetTodoUsecase();
    mockAddTodoUsecase = MockAddTodoUsecase();
    mockDeleteTodoUsecase = MockDeleteTodoUsecase();
    mockToggleTodoUsecase = MockToggleTodoUsecase();
    todoBloc = TodoBloc(
        getTodoUsecase: mockGetTodoUsecase,
        addTodoUsecase: mockAddTodoUsecase,
        toggleTodoUsecase: mockToggleTodoUsecase,
        deleteTodoUsecase: mockDeleteTodoUsecase);
  });

  group('Initial State', () {
    test('Initial state should be TodoInitial ', () {
      expect(todoBloc.state, TodoInitial());
    });
  });

  group('Get Todos', () {
    test('Bloc calls get todo usecase', () async {
      // Arrange
      when(() => mockGetTodoUsecase.execute())
          .thenAnswer((invocation) async => todos);
      // Act
      todoBloc.add(GetTodoEvent());
      await untilCalled(() => mockGetTodoUsecase.execute());
      // Assert
      verify(() => mockGetTodoUsecase.execute());
      verifyNoMoreInteractions(mockGetTodoUsecase);
    });

    blocTest(
      'Should emit correct order of states when get todos is called with success',
      build: () {
        when(() => mockGetTodoUsecase.execute())
            .thenAnswer((invocation) async => todos);
        return todoBloc;
      },
      act: (bloc) {
        return todoBloc.add(GetTodoEvent());
      },
      expect: () {
        return [TodoLoading(), TodosLoaded(todos: todos)];
      },
    );

    blocTest(
      'Should emit correct order of states when get todos is called with error',
      build: () {
        when(() => mockGetTodoUsecase.execute()).thenThrow(error);
        return todoBloc;
      },
      act: (bloc) {
        return todoBloc.add(GetTodoEvent());
      },
      expect: () {
        return [TodoLoading(), TodosLoadedWithError(message: error.message)];
      },
    );
  });

  group('Add Todo', () {
    test('Bloc calls add todo usecase', () async {
      // Arrange
      when(() => mockAddTodoUsecase.execute(todo: todo))
          .thenAnswer((invocation) async => todos);
      // Act
      todoBloc.add(AddTodoEvent(todo: todo));
      await untilCalled(() => mockAddTodoUsecase.execute(todo: todo));
      // Assert
      verify(() => mockAddTodoUsecase.execute(todo: todo));
      verifyNoMoreInteractions(mockAddTodoUsecase);
    });

    blocTest(
      'Should emit correct order of states when add todo is called with success',
      build: () {
        when(() => mockAddTodoUsecase.execute(todo: todo))
            .thenAnswer((invocation) async => todos);
        return todoBloc;
      },
      act: (bloc) {
        return todoBloc.add(AddTodoEvent(todo: todo));
      },
      expect: () {
        return [TodoLoading(), TodosLoaded(todos: todos)];
      },
    );

    blocTest(
      'Should emit correct order of states when add todos is called with error',
      build: () {
        when(() => mockAddTodoUsecase.execute(todo: todo)).thenThrow(error);
        return todoBloc;
      },
      act: (bloc) {
        return todoBloc.add(AddTodoEvent(todo: todo));
      },
      expect: () {
        return [TodoLoading(), TodosLoadedWithError(message: error.message)];
      },
    );
  });

  group('Delete Todo', () {
    test('Bloc calls delete todo usecase', () async {
      // Arrange
      when(() => mockDeleteTodoUsecase.execute(id: id))
          .thenAnswer((invocation) async => todos);
      // Act
      todoBloc.add(DeleteTodoEvent(id: id));
      await untilCalled(() => mockDeleteTodoUsecase.execute(id: id));
      // Assert
      verify(() => mockDeleteTodoUsecase.execute(id: id));
      verifyNoMoreInteractions(mockDeleteTodoUsecase);
    });

    blocTest(
      'Should emit correct order of states when delete todo is called with success',
      build: () {
        when(() => mockDeleteTodoUsecase.execute(id: id))
            .thenAnswer((invocation) async => todos);
        return todoBloc;
      },
      act: (bloc) {
        return todoBloc.add(DeleteTodoEvent(id: id));
      },
      expect: () {
        return [TodoLoading(), TodosLoaded(todos: todos)];
      },
    );

    blocTest(
      'Should emit correct order of states when delete todos is called with error',
      build: () {
        when(() => mockDeleteTodoUsecase.execute(id: id)).thenThrow(error);
        return todoBloc;
      },
      act: (bloc) {
        return todoBloc.add(DeleteTodoEvent(id: id));
      },
      expect: () {
        return [TodoLoading(), TodosLoadedWithError(message: error.message)];
      },
    );
  });

  group('Toggle Todo', () {
    test('Bloc calls toggle todo usecase', () async {
      // Arrange
      when(() => mockToggleTodoUsecase.execute(id: id))
          .thenAnswer((invocation) async => todos);
      // Act
      todoBloc.add(ToggleTodoEvent(id: id));
      await untilCalled(() => mockToggleTodoUsecase.execute(id: id));
      // Assert
      verify(() => mockToggleTodoUsecase.execute(id: id));
      verifyNoMoreInteractions(mockToggleTodoUsecase);
    });

    blocTest(
      'Should emit correct order of states when toggle todo is called with success',
      build: () {
        when(() => mockToggleTodoUsecase.execute(id: id))
            .thenAnswer((invocation) async => todos);
        return todoBloc;
      },
      act: (bloc) {
        return todoBloc.add(ToggleTodoEvent(id: id));
      },
      expect: () {
        return [TodoLoading(), TodosLoaded(todos: todos)];
      },
    );

    blocTest(
      'Should emit correct order of states when toggle todos is called with error',
      build: () {
        when(() => mockToggleTodoUsecase.execute(id: id)).thenThrow(error);
        return todoBloc;
      },
      act: (bloc) {
        return todoBloc.add(ToggleTodoEvent(id: id));
      },
      expect: () {
        return [TodoLoading(), TodosLoadedWithError(message: error.message)];
      },
    );
  });
}
