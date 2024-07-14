import 'dart:io';

///
/// any request
/// http://localhost:8080/fibonacci
/// http://localhost:8080/json
/// http://localhost:8080/echo
/// http://localhost:8080/echo/message
///
Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  server.listen((request) async {
    print(request.requestedUri);
    request.response.close();
  });
}