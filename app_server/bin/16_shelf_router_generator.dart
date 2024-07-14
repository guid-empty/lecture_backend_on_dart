import 'dart:io';

import 'package:app_server/src/16_domain_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

///
/// http://localhost:8080/order
/// http://localhost:8080/user
///
Future<void> main() async {
  final handler = Cascade()
      .add(UserController().router)
      .add(OrderController().router)
      .handler;

  final pipeline = Pipeline().addMiddleware(logRequests()).addHandler(handler);

  await serve(pipeline, InternetAddress.anyIPv4, 8080);
}
