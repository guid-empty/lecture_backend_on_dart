import 'dart:async';
import 'dart:convert';

import 'package:web_client/common/json_pretty_printer_extension.dart';
import 'package:web_client/logging/logger.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

typedef JSON = Map<String, dynamic>;

String get webSocketHost => const String.fromEnvironment(
      'WEBSOCKET_SERVER_URL',
      defaultValue: 'ws://localhost',
    );

class RealtimeGateway {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _channelListenerSubscription;

  final StreamController<JSON> _messageReceivedStreamController =
      StreamController<JSON>.broadcast();

  Stream<JSON> get onMessage => _messageReceivedStreamController.stream;

  /// sessionId содержит два идентификатора - userId + Id окна браузера,
  /// разделенные символом ":"
  Future<void> connect({
    required String sessionId,
  }) async {
    _channel?.sink.close(status.normalClosure);
    _channel = WebSocketChannel.connect(
        Uri.parse('$webSocketHost:8080/ws/connect/$sessionId'));

    _channelListenerSubscription = _channel?.stream.listen(
      (data) {
        final message = jsonDecode(data) as JSON;
        logger.info('WebSocket message ${message.prettyPrint()}');
        _messageReceivedStreamController.sink.add(message);
      },
      onDone: () async {
        logger.info('closed the socket');
      },
      onError: (e, s) async {
        logger.severe('abnormal closing the socket by error', e, s);
        await _channel?.sink.close(status.abnormalClosure);
      },
    );
  }

  Future<void> dispose() async {
    await _channelListenerSubscription?.cancel();
    await _channel?.sink.close(status.normalClosure);
  }

  void sendMessage(JSON message) => _channel?.sink.add(jsonEncode(message));
}
