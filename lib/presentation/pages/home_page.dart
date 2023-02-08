import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc_riverpod/domain/entities/todo.dart';
import 'package:todo_bloc_riverpod/presentation/bloc/todo_bloc.dart';
import 'package:todo_bloc_riverpod/presentation/bloc/todo_event.dart';
import 'package:uuid/uuid.dart';

import '../bloc/todo_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TodoBloc>(context).add(GetTodoEvent());
  }

  void _addTodo({required String value}) {
    final todo = Todo(id: const Uuid().v4(), completed: false, title: value);
    BlocProvider.of<TodoBloc>(context).add(AddTodoEvent(todo: todo));
    _textFieldController.clear();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (_textFieldController.text.isNotEmpty) {
                    _addTodo(value: _textFieldController.text);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
            title: const Text('Create a Todo'),
            content: TextField(
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _addTodo(value: value);
                  Navigator.of(context).pop();
                }
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Add your Todo"),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoaded) {
            if (state.todos.isEmpty) {
              return const Center(
                child: Text('Add your first todo'),
              );
            } else {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  return Dismissible(
                    background: Container(
                        color: Colors.red,
                        child: Row(children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: Text('DELETE',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white)),
                          )
                        ])),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        BlocProvider.of<TodoBloc>(context)
                            .add(DeleteTodoEvent(id: todo.id));
                      }
                    },
                    key: Key(todo.id),
                    child: ListTile(
                      title: Text(todo.title),
                      trailing: IconButton(
                        icon: todo.completed
                            ? const Icon(Icons.done)
                            : const Icon(Icons.circle_outlined),
                        onPressed: () {
                          BlocProvider.of<TodoBloc>(context)
                              .add(ToggleTodoEvent(id: todo.id));
                        },
                      ),
                    ),
                  );
                },
              );
            }
          } else if (state is TodosLoadedWithError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _displayTextInputDialog(context);
        },
      ),
    );
  }
}
