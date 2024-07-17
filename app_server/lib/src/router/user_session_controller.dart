import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_server/src/data/todo_repository.dart';
import 'package:app_server/src/logging/logger.dart';
import 'package:app_server/src/router/ws/web_socket_session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

part 'user_session_controller.g.dart';

class UserSessionController {
  final TodoRepository _todoRepository;

  UserSessionController({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  @protected
  Map<String, String> get jsonContentHeaders => const {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        'X-Powered-By': 'shmr_server.io api',
      };

  Router get router => _$UserSessionControllerRouter(this);

  final _websocketConnections = <String, WebSocketSession>{};

  @Route.get('/ws/connect/<token>')
  Future<Response> connect(Request request, String token) async {
    return _wrapResponse(
      () async {
        return webSocketHandler((ws) => WebSocketSession(
              onOpen: (ws) {
                logger.t('onOpen handler: connection established with $token');
                _websocketConnections[token]?.close();
                _websocketConnections[token] = ws;
              },
              onClose: (ws) {
                final entries = _websocketConnections.entries
                    .where((entry) => entry.value == ws)
                    .toList();

                for (final entry in entries) {
                  logger
                      .t('onClose handler: connection closed for ${entry.key}');
                  _websocketConnections.remove(entry.key);
                }
              },
              onMessage: (ws, dynamic data) {
                logger.t('onMessage handler: $data received');
                _processWebSocketMessage(data, token);
              },
            )..init(ws)).call(request);
      },
    );
  }

  void _processWebSocketMessage(dynamic data, String token) {
    try {
      final message = jsonDecode(data) as Map<String, dynamic>;
      if (message.containsKey('ping')) {
        _websocketConnections[token]?.send('pong');
      }
    } on Object catch (e, s) {
      logger.severe('Processing failed for message $data', e, s);
    }
  }

  Future<Response> _wrapResponse(
    FutureOr<Response> Function() createBody,
  ) async {
    try {
      final result = await createBody();
      return result;
    } on Object catch (e, s) {
      logger.severe(e, s);
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
