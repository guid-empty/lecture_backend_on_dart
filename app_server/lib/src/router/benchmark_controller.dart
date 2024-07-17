import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_server/src/data/todo_repository.dart';
import 'package:app_server/src/logging/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'benchmark_controller.g.dart';

class BenchmarkController {
  final TodoRepository _todoRepository;

  BenchmarkController({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @protected
  Map<String, String> get jsonContentHeaders => const {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        'X-Powered-By': 'shmr_server.io api',
      };

  Router get router => _$BenchmarkControllerRouter(this);

  @Route.get('/benchmark')
  Future<Response> createBenchmark(Request request) async {
    return _wrapResponse(
      () async {
        await _todoRepository.benchmark();
        return Response.ok(
          null,
          headers: jsonContentHeaders,
        );
      },
    );
  }

  Future<Response> _wrapResponse(
    FutureOr<Response> Function() createBody,
  ) async {
    try {
      final result = await createBody();
      return result;
    } on Object catch (e, s) {
      if (e is! HijackException) {
        logger.severe(e, e, s);
      }

      return Response.badRequest(
        body: jsonEncode(
          {
            'error': e.toString(),
            'stack_trace': s.toString(),
          },
        ),
        headers: jsonContentHeaders,
      );
    }
  }
}
