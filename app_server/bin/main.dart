import 'dart:io';

import 'package:app_server/src/data/todo_repository.dart';
import 'package:app_server/src/logging/logger.dart';
import 'package:app_server/src/router/authentication_check_middleware.dart';
import 'package:app_server/src/router/benchmark_controller.dart';
import 'package:app_server/src/router/todo_controller.dart';
import 'package:app_server/src/router/user_session_controller.dart';
import 'package:firebase_admin/firebase_admin.dart' as firebase_admin;
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;

Future<void> main() async {
  await LoggerSettings.initLogging(instancePrefix: 'SHMR Server');
  final connectionHost = Platform.environment['POSTGRESQL_HOST'];
  logger.info('Postgresql connection Host is $connectionHost');

  final connection = await Connection.open(
    Endpoint(
      host: Platform.environment['POSTGRESQL_HOST'] ?? 'postgresql',
      database: 'shmr_todolist',
      username: 'postgres',
      password: 'password',
    ),
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );

  ///
  ///   static Credential? _getApplicationDefault() {
  ///     var f = File('service-account.json');
  ///     if (f.existsSync()) {
  ///       return _credentialFromFile(f.path);
  ///     }
  final firebaseAdminSDKApp =
      firebase_admin.FirebaseAdmin.instance.initializeApp(
    firebase_admin.AppOptions(
      credential: firebase_admin.Credentials.applicationDefault()!,
      projectId: 'server-on-dart',
    ),
  );

  final todoRepository = TodoRepository(connection: connection);

  final handler = Cascade()
      .add(TodoController(todoRepository: todoRepository).router)
      .add(UserSessionController(todoRepository: todoRepository).router)
      .add(BenchmarkController(todoRepository: todoRepository).router)
      .handler;

  final pipeline = Pipeline()
      .addMiddleware(cors.corsHeaders(headers: {
        HttpHeaders.accessControlAllowHeadersHeader: '*',
        HttpHeaders.accessControlAllowMethodsHeader:
            'HEAD, GET, POST, PUT, DELETE, PATCH, OPTIONS',
        HttpHeaders.accessControlAllowOriginHeader: '*',
      }))
      .addMiddleware(logRequests())
      .addMiddleware(
        AuthenticationCheckMiddleware.createAuthenticationCheckMiddleware(
          firebaseAdminSDKApp: firebaseAdminSDKApp,
        ),
      )
      .addHandler(handler);
  logger.info('server is ready to start');
  await serve(pipeline, InternetAddress.anyIPv4, 8080);
}
