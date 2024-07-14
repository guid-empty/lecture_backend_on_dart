import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

///
/// resources
/// https://overload.yandex.net/
/// https://github.com/mcollina/autocannon - autocannon
/// https://yandextank.readthedocs.io/en/latest/intro.html - yandex tank/
///
/// autocannon -c 100 -d 10 --debug http://localhost:8080/fibonacci
/// yandex-tank -c load.yaml
///
///
///
Future<void> main() async {
  final router = Router()..get('/fibonacci', _fibonacciHandler);

  final pipeline = Pipeline().addMiddleware(logRequests()).addHandler(router);

  await serve(pipeline, InternetAddress.anyIPv4, 8080);
}

int _fibonacci(int n) => n <= 2 ? 1 : _fibonacci(n - 2) + _fibonacci(n - 1);

Future<Response> _fibonacciHandler(Request request) async =>
    Response.ok(_fibonacci(32).toString());