import 'dart:io';

import 'package:app_server/src/data/todo_repository.dart';
import 'package:app_server/src/logging/logger.dart';
import 'package:app_server/src/router/todo_controller.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;

Future<void> main() async {
  await LoggerSettings.initLogging(instancePrefix: 'SHMR Server');
  final connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'shmr_todolist',
        username: 'postgres',
        password: 'password',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable));

  final todoRepository = TodoRepository(connection: connection);

  final handler = Cascade()
      .add(TodoController(todoRepository: todoRepository).router)
      .handler;

  final pipeline = Pipeline()
      .addMiddleware(cors.corsHeaders())
      // .addMiddleware(cors.corsHeaders(headers: {
      //   HttpHeaders.accessControlAllowHeadersHeader: '*',
      //   HttpHeaders.accessControlAllowMethodsHeader:
      //       'HEAD, GET, POST, PUT, DELETE, PATCH, OPTIONS',
      //   HttpHeaders.accessControlAllowOriginHeader: '*',
      // }))
      .addMiddleware(logRequests())
      .addHandler(handler);
  logger.info('server is ready to start');
  await serve(pipeline, InternetAddress.anyIPv4, 8080);
}
