import 'package:web_client/api/todo_api.dart';
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

  Future<void> completeTodo(TodoModel todo) async {
    await _todoApi.updateTodo(todo.id, todo.title, true);
  }

  Future<void> unCompleteTodo(TodoModel todo) async {
    await _todoApi.updateTodo(todo.id, todo.title, false);
  }
}
