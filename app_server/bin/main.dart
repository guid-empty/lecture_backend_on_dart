import 'dart:io';

import 'package:app_server/src/data/todo_repository.dart';
import 'package:app_server/src/router/todo_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

Future<void> main() async {
  final todoRepository = TodoRepository();

  final handler = Cascade()
      .add(TodoController(todoRepository: todoRepository).router)
      .handler;

  final pipeline = Pipeline().addMiddleware(logRequests()).addHandler(handler);
  await serve(pipeline, InternetAddress.anyIPv4, 8080);
}
