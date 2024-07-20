import 'package:dio/dio.dart';
import 'package:web_client/api/create_todo_request.dart';
import 'package:web_client/api/update_todo_request.dart';
import 'package:web_client/domain/todo_model.dart';

class TodoApi {
  final Dio _dio;

  String get appHost => const String.fromEnvironment(
        'APP_SERVER_URL',
        defaultValue: 'http://localhost',
      );

  TodoApi({required Dio dio}) : _dio = dio;

  Future<Iterable<TodoModel>> getTodos() async {
    final response = await _dio.get<List<dynamic>>('$appHost:8080/todo');
    final json = response.data as List<dynamic>;

    return json.map((e) {
      final todoDto = e as Map<String, dynamic>;
      return TodoModel.fromJson(todoDto);
    }).toList();
  }

  Future<void> saveTodo(String title, bool isCompleted) async {
    await _dio.post<Map<String, dynamic>>('$appHost:8080/create',
        data: CreateTodoRequest(
          isCompleted: isCompleted,
          title: title,
        ).toJson());
  }

  Future<void> updateTodo(int id, String title, bool isCompleted) async {
    await _dio.put<Map<String, dynamic>>('$appHost:8080/todo/$id',
        data: UpdateTodoRequest(
          isCompleted: isCompleted,
          title: title,
        ).toJson());
  }
}
