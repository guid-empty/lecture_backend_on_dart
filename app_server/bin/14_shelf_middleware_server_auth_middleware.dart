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
      .addMiddleware(createAuthenticationCheckMiddleware())
      .addHandler(router);

  await serve(pipeline, InternetAddress.anyIPv4, 8080);
}

Middleware createAuthenticationCheckMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      //  выполним проверку, если что-то не в порядке, то вернем 403
      final oauthToken = request.headers[HttpHeaders.authorizationHeader];
      if (oauthToken == null || oauthToken.isEmpty) {
        return Response.forbidden('Not authroized request');
      }

      //  можем воспользоваться свойством context, куда можем поместить какую
      //  то полезную информацию для переиспользования в самих http handlers,
      //  например, если уже сходили в базу за userDto, передать его, чтобы
      //  не ходить в базу данных еще раз
      request = request.change(
        context: {
          ...request.context,
          'user': {'id': -1},
        },
      );

      //  все хорошо, позволим нашему pipeline отработать дальше
      final response = await innerHandler(request);
      return response;

      //  можем дополнительно выполнить какие то модификации в теле ответа или
      //  добавить http headers (например, время выполнения запроса на стороне
      //  сервера)
      return response.change(
        headers: {
          'X-Request-Process-Duration': 143.toString(),
        },
      );
    };
  };
}

Future<Response> _echoHandler(Request request) async {
  final message = request.params['message'];
  final userDto = request.context['user'];
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
