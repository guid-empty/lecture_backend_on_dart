import 'package:flutter/material.dart';
import 'package:web_client/data/todo_repository.dart';
import 'package:web_client/di.dart';
import 'package:web_client/domain/todo_model.dart';
import 'package:web_client/widgets/todo_item.dart';

class TodoPage extends StatefulWidget {
  final String title;
  final TodoRepository todoRepository;

  const TodoPage({
    required this.todoRepository,
    required this.title,
    super.key,
  });

  @override
  State<TodoPage> createState() => TodoPageState();
}

@visibleForTesting
class TodoPageState extends State<TodoPage> {
  ScrollController scrollController = ScrollController();
  TodoModel? selectedTodo;
  late Future<Iterable<TodoModel>> _todoListFetcher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<Iterable<TodoModel>>(
          future: _todoListFetcher,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final todos = snapshot.requireData.toList();

              return ListView.builder(
                key: const Key('long_list'),
                controller: scrollController,
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return GestureDetector(
                    onTap: () => setState(() => selectedTodo = todo),
                    child: ListTile(
                      selected: _isSelected(todo),
                      selectedTileColor: theme.primaryColor,
                      selectedColor: theme.scaffoldBackgroundColor,
                      tileColor: todo.isCompleted ? theme.disabledColor : null,
                      title: TodoItemWidget(
                        item: todo,
                        key: ValueKey('item_${todo.id}'),
                        onCheckBoxTap: _handleCheckBoxTap,
                      ),
                    ),
                  );
                },
              );
            }

            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {}

            return const CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('todo_creation'),
        onPressed: _createTask,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void initState() {
    super.initState();
    _todoListFetcher = DI.todoRepository.fetchAll();
  }

  Future<void> _createTask() async {
    await DI.todoRepository.create(
      title: 'Новая задача',
      isCompleted: false,
    );

    setState(() {
      _todoListFetcher = DI.todoRepository.fetchAll()
        ..then((value) => selectedTodo = value.lastOrNull);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
            scrollController.position.maxScrollExtent,
          );
        }
      });
    });
  }

  void _handleCheckBoxTap(TodoModel todo) {
    if (todo.isCompleted) {
      DI.todoRepository.unCompleteTodo(todo);
    } else {
      DI.todoRepository.completeTodo(todo);
    }

    setState(() {
      _todoListFetcher = DI.todoRepository.fetchAll()
        ..then((value) => selectedTodo = value.lastOrNull);
    });
  }

  bool _isSelected(TodoModel todo) => selectedTodo?.id == todo.id;
}