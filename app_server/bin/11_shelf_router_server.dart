import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

///
/// http://localhost:8080/json
/// http://localhost:8080/echo/somemessage
/// http://localhost:8080/delete/<id>
/// http://localhost:8080/create/<name>
/// http://localhost:8080/echo/somemessage/error
///
Future<void> main() async {
  final router = Router()
    ..get('/json', _jsonHandler)
    ..get('/echo/<message>', _echoHandler)
    ..delete('/delete/<id>', _deleteEntityHandler)
    ..put('/create/<name>', _createEntityHandler)
    ..post('/archive', _archiveEntitiesHandler);

  await serve(router, InternetAddress.anyIPv4, 8080);
}

Future<Response> _archiveEntitiesHandler(Request request) async =>
    Response.ok('');

Future<Response> _createEntityHandler(Request request) async {
  final message = request.params['name'];

  return Response.ok('$message\n');
}

Future<Response> _deleteEntityHandler(Request request) async {
  final message = request.params['id'];

  return Response.ok('$message\n');
}

Future<Response> _echoHandler(Request request) async {
  final message = request.params['message'];

  return Response.ok('$message\n');
}

Future<Response> _jsonHandler(Request request) async {
  return Response.ok(
    jsonEncode(
      {'operation_details': 10},
    ),
    headers: {
      'Content-Type': 'application/json',
    },
  );
}
