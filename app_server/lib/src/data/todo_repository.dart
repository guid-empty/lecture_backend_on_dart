import 'package:app_server/src/domain/todo_model.dart';
import 'package:collection/collection.dart';

class TodoRepository {
  /// InMemory хранилище данных
  Set<TodoModel> _todos = {
    const TodoModel(id: 2, title: 'Task 2', isCompleted: false),
    const TodoModel(id: 4, title: 'Task 4', isCompleted: false),
    const TodoModel(id: 3, title: 'Task 3', isCompleted: false),
    const TodoModel(id: 1, title: 'Task 1', isCompleted: false),
    const TodoModel(id: 5, title: 'Task 5', isCompleted: false),
  };

  /// Получить из хранилища все задачи в отсортированном порядке
  Iterable<TodoModel> fetchAll() =>
      _todos.sorted((a, b) => a.id.compareTo(b.id));

  /// Создать новую задачу
  TodoModel create({
    required String title,
    bool isCompleted = false,
  }) {
    final sortedTodos = fetchAll();
    final id = sortedTodos.last.id + 1;

    final todo = TodoModel(id: id, title: title, isCompleted: isCompleted);
    _todos.add(todo);

    return todo;
  }

  /// Удалить задачу по ее Id
  void removeById(int id) {
    _guard(id);
    _todos = _todos.where((e) => e.id != id).toSet();
  }

  /// Завершить задачу
  void completeTodo(TodoModel todo) {
    _guard(todo.id);
    _todos = _todos
        .map((e) => e == todo ? e.copyWith(isCompleted: true) : e)
        .toSet();
  }

  /// Восстановить задачу в незавершенное состояние
  void unCompleteTodo(TodoModel todo) {
    _guard(todo.id);
    _todos = _todos
        .map((e) => e == todo ? e.copyWith(isCompleted: false) : e)
        .toSet();
  }

  /// Обновить задачу
  void update({
    required int id,
    required String title,
    bool? isCompleted,
  }) {
    _guard(id);
    _todos = _todos
        .map((e) => e.id == id
            ? e.copyWith(
                title: title,
                isCompleted: isCompleted ?? e.isCompleted,
              )
            : e)
        .toSet();
  }

  /// Проверяет наличие задачи в хранилище
  void _guard(int id) {
    if (_todos.none((e) => e.id == id)) {
      throw NotFoundException('There are no todo with id = $id!');
    }
  }
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException{message: $message}';
}
