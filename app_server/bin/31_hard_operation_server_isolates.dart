import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> main() async {
  final cpuCount = math.max((Platform.numberOfProcessors / 2).round(), 2);
  print('Starting server in $cpuCount isolates');

  final servers = <Future<Isolate>>[];
  for (var i = 0; i <= cpuCount; i++) {
    servers.add(
      Isolate.spawn(
        (_) async {
          final router = Router()..get('/fibonacci', _fibonacciHandler);
          final pipeline =
              Pipeline().addMiddleware(logRequests()).addHandler(router);
          await serve(pipeline, InternetAddress.anyIPv4, 8080, shared: true);
        },
        null,
        debugName: 'Server $i',
      ),
    );
  }

  final isolates = await Future.wait(servers);
  stdout.writeln('Press any key to stop the server');
  stdin.readLineSync();
  for (final isolate in isolates) {
    isolate.kill();
  }
}

int _fibonacci(int n) => n <= 2 ? 1 : _fibonacci(n - 2) + _fibonacci(n - 1);

Future<Response> _fibonacciHandler(Request request) async =>
    Response.ok(_fibonacci(32).toString());
