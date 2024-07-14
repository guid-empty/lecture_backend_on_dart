import 'dart:convert';
import 'dart:developer';
import 'dart:io';

///
/// just Hello part in path
/// http://localhost:8080/hello
///
Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  await for (final request in server) {
    final uri = request.requestedUri;
    final segments = uri.pathSegments;
    try {
      if (segments[0] == 'hello') {
        final response = {'body': 'data'};
        request.response.write(jsonEncode(response));
      } else {
        request.response.statusCode = HttpStatus.badRequest;
      }
    } catch (e, s) {
      log('$e, $s');
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.writeln(e);
    }
    await request.response.close();
  }
}
