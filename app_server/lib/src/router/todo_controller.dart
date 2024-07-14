import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_server/src/api/create_todo_request.dart';
import 'package:app_server/src/api/update_todo_request.dart';
import 'package:app_server/src/data/todo_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'todo_controller.g.dart';

class TodoController {
  final TodoRepository _todoRepository;

  TodoController({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @protected
  Map<String, String> get jsonContentHeaders => const {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        'X-Powered-By': 'shmr_server.io api',
      };

  Router get router => _$TodoControllerRouter(this);

  @Route.post('/create')
  Future<Response> createTodo(Request request) async {
    final body = await request.readAsString();
    final createTodoRequest = CreateTodoRequest.fromJson(
      jsonDecode(body),
    );
    return _wrapResponse(
      () async => Response.ok(
        jsonEncode(
          await _todoRepository.create(
            title: createTodoRequest.title,
            isCompleted: createTodoRequest.isCompleted,
          ),
        ),
        headers: jsonContentHeaders,
      ),
    );
  }

  @Route.delete('/todo/<todoId>')
  Future<Response> deleteTodo(Request request) async {
    return _wrapResponse(
      () async {
        final todoId = int.tryParse(request.params['todoId'] ?? '-1') ?? -1;
        _todoRepository.removeById(todoId);

        return Response.ok(
          null,
          headers: jsonContentHeaders,
        );
      },
    );
  }

  @Route.get('/todo')
  Future<Response> getTodoList(Request request) async {
    return _wrapResponse(
      () async => Response.ok(
        jsonEncode(
          await _todoRepository.fetchAll(),
        ),
        headers: jsonContentHeaders,
      ),
    );
  }

  @Route.put('/todo/<todoId>')
  Future<Response> updateTodo(Request request) async {
    final body = await request.readAsString();
    final updateTodoRequest = UpdateTodoRequest.fromJson(
      jsonDecode(body),
    );
    return _wrapResponse(
      () async {
        final todoId = int.tryParse(request.params['todoId'] ?? '-1') ?? -1;

        _todoRepository.update(
          id: todoId,
          title: updateTodoRequest.title,
          isCompleted: updateTodoRequest.isCompleted,
        );

        return Response.ok(
          null,
          headers: jsonContentHeaders,
        );
      },
    );
  }

  Future<Response> _wrapResponse(
    FutureOr<Response> Function() createBody,
  ) async {
    try {
      final result = await createBody();
      return result;
    } on Object catch (e, s) {
      return Response.badRequest(
        body: jsonEncode(
          {
            'error': e.toString(),
            'stack_trace': s.toString(),
          },
        ),
        headers: jsonContentHeaders,
      );
    }
  }
}
