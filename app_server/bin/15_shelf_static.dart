import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

///
/// Статические ресурсы можем расшарить, указав некий фолдер, из которого
/// мы будем отдавать ресурсы, например
/// http://127.0.0.1:8080/resources/logo.png?1
///
Future<void> main() async {
  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(createStaticHandler('public'));

  await serve(pipeline, InternetAddress.anyIPv4, 8080);
}
