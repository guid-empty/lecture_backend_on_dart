import 'package:app_server/src/domain/todo_model.dart';
import 'package:app_server/src/logging/logger.dart';
import 'package:collection/collection.dart';
import 'package:postgres/postgres.dart';

class TodoRepository {
  final Connection _connection;

  /// InMemory хранилище данных
  Set<TodoModel> _todos = {
    const TodoModel(id: 2, title: 'Task 2', isCompleted: false),
    const TodoModel(id: 4, title: 'Task 4', isCompleted: false),
    const TodoModel(id: 3, title: 'Task 3', isCompleted: false),
    const TodoModel(id: 1, title: 'Task 1', isCompleted: false),
    const TodoModel(id: 5, title: 'Task 5', isCompleted: false),
  };

  TodoRepository({
    required Connection connection,
  }) : _connection = connection;

  /// Получить из хранилища все задачи в отсортированном порядке
  Future<Iterable<TodoModel>> fetchAll() async {
    final result = await _connection.execute(
      Sql.named('SELECT * FROM todolist ORDER BY id ASC'),
    );
    logger.info(result.first.toColumnMap());
    final models =
        result.map((e) => TodoModel.fromJson(e.toColumnMap())).toList();
    return models;
  }

  /// Создать новую задачу
  Future<TodoModel> create({
    required String title,
    bool isCompleted = false,
  }) async {
    final result = await _connection.execute(
        Sql.named('INSERT INTO todolist (title, is_completed) '
            'VALUES (@title, @isCompleted) '
            'RETURNING *'),
        parameters: {
          'title': title,
          'isCompleted': isCompleted,
        });
    final serializedState = result.first.toColumnMap();
    return TodoModel.fromJson(serializedState);
  }

  /// Удалить задачу по ее Id
  /// TODO:
  void removeById(int id) {
    _guard(id);
    _todos = _todos.where((e) => e.id != id).toSet();
  }

  /// Завершить задачу
  /// TODO:
  void completeTodo(TodoModel todo) {
    _guard(todo.id);
    _todos = _todos
        .map((e) => e == todo ? e.copyWith(isCompleted: true) : e)
        .toSet();
  }

  /// Восстановить задачу в незавершенное состояние
  /// TODO:
  void unCompleteTodo(TodoModel todo) {
    _guard(todo.id);
    _todos = _todos
        .map((e) => e == todo ? e.copyWith(isCompleted: false) : e)
        .toSet();
  }

  /// Обновить задачу
  /// TODO:
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
