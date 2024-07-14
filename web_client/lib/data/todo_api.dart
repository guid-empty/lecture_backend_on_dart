import 'package:dio/dio.dart';
import 'package:web_client/api/create_todo_request.dart';
import 'package:web_client/domain/todo_model.dart';

class TodoApi {
  final Dio _dio;

  TodoApi({required Dio dio}) : _dio = dio;

  Future<Iterable<TodoModel>> getTodos() async {
    final response =
        await _dio.get<List<dynamic>>('http://localhost:8080/todo');
    final json = response.data as List<dynamic>;

    return json.map((e) {
      final todoDto = e as Map<String, dynamic>;
      return TodoModel.fromJson(todoDto);
    }).toList();
  }

  Future<void> saveTodo(String title, bool isCompleted) async {
    await _dio.post<Map<String, dynamic>>('http://localhost:8080/create',
        data: CreateTodoRequest(
          isCompleted: isCompleted,
          title: title,
        ).toJson());
  }
}
