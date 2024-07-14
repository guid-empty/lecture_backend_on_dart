import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

///
/// http://localhost:8080/json
/// http://localhost:8080/echo/somemessage
/// http://localhost:8080/echo/somemessage/error
///
Future<void> main() async {
  final router = Router()
    ..get('/json', _jsonHandler)
    ..get('/echo/<message>', _echoHandler);

  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  await serve(pipeline, InternetAddress.anyIPv4, 8080);
}

Future<void> _checkAuthentication(String? token) async {
  if (token?.contains('Bearer') ?? false) {
    //  some validation logic here
  }
}

Future<Response> _echoHandler(Request request) async {
  final oauthToken = request.headers[HttpHeaders.authorizationHeader];
  await _checkAuthentication(oauthToken);

  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _jsonHandler(Request request) async {
  final oauthToken = request.headers[HttpHeaders.authorizationHeader];
  await _checkAuthentication(oauthToken);

  return Response.ok(
    jsonEncode(
      {'operation_details': 10},
    ),
    headers: {
      'Content-Type': 'application/json',
    },
  );
}
