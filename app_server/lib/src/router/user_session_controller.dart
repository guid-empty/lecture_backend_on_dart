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

  /// sessionId содержит два идентификатора - userId + Id окна браузера,
  /// разделенные символом ":"
  @Route.get('/ws/connect/<sessionId>')
  Future<Response> connect(Request request, String sessionId) async {
    return _wrapResponse(
      () async {
        return webSocketHandler((ws) => WebSocketSession(
              onOpen: (ws) {
                logger.t(
                    'onOpen handler: connection established with $sessionId');
                _websocketConnections[sessionId]?.close();
                _websocketConnections[sessionId] = ws;
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
                _processWebSocketMessage(data, sessionId);
              },
            )..init(ws)).call(request);
      },
    );
  }

  /// sessionId содержит два идентификатора - userId + Id окна браузера,
  /// разделенные символом "-"
  void _processWebSocketMessage(dynamic data, String sessionId) {
    try {
      final message = jsonDecode(data) as Map<String, dynamic>;
      if (message.containsKey('sign_out')) {
        final userId = message['sign_out'];

        for (final entry in _websocketConnections.entries) {
          //  для всех сокетов, которые были открыты для пользователя
          if (entry.key.startsWith(userId)) {
            final windowKey = entry.key.split(':')[1];

            _websocketConnections[entry.key]?.send(
              jsonEncode(
                {
                  'close_session': true,
                  'user_id': userId,
                  'window_key': windowKey,
                },
              ),
            );
          }
          _websocketConnections[entry.key]?.close();
        }
        _websocketConnections
            .removeWhere((key, value) => key.startsWith(userId));
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
