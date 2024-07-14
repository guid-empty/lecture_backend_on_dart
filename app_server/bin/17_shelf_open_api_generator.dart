import 'dart:io';

import 'package:app_server/src/17_open_api_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

///
/// http://localhost:8080/order
/// http://localhost:8080/user
/// http://localhost:8080/resources/logo.png
/// http://localhost:8080/src/api.open_api.yaml
/// http://localhost:8080/openapi/
///
Future<void> main() async {
  final handler = Cascade()
      .add(UserController().router)
      .add(OrderController().router)
      .add(createStaticHandler('public/'))
      .add(
        Router()
          ..mount(
            '/openapi/',
            SwaggerUI(
              'public/src/api.open_api.yaml',
              docExpansion: DocExpansion.list,
              syntaxHighlightTheme: SyntaxHighlightTheme.tomorrowNight,
              title: 'OpenApiService Demo Generation handler',
            ),
          ),
      )
      .handler;

  await serve(handler, InternetAddress.anyIPv4, 8080);
}
