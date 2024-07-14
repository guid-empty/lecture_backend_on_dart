import 'package:web_client/data/todo_api.dart';
import 'package:web_client/domain/todo_model.dart';

class TodoRepository {
  final TodoApi _todoApi;

  TodoRepository({
    required TodoApi todoApi,
  }) : _todoApi = todoApi;

  /// Создать новую задачу
  Future<void> create({required String title, bool isCompleted = false}) async {
    await _todoApi.saveTodo(title, isCompleted);
  }

  /// Получить из хранилища все задачи
  Future<Iterable<TodoModel>> fetchAll() => _todoApi.getTodos();

  Future<Iterable<TodoModel>> completeTodo(TodoModel todo) =>
      _todoApi.getTodos();

  Future<Iterable<TodoModel>> unCompleteTodo(TodoModel todo) =>
      _todoApi.getTodos();
}
