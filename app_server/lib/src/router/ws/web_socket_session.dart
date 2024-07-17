import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

///
/// see more details in [shelf_plus] package
///
class WebSocketSession {
  late WebSocketChannel channel;

  FutureOr<void> Function(WebSocketSession session)? onOpen;

  FutureOr<void> Function(WebSocketSession session, dynamic data)? onMessage;

  FutureOr<void> Function(WebSocketSession session)? onClose;

  FutureOr<void> Function(WebSocketSession session, dynamic error)? onError;

  WebSocketSession({
    this.onOpen,
    this.onMessage,
    this.onClose,
    this.onError,
  });

  WebSocketSink get sender => channel.sink;

  void close() => channel.sink.close();

  void init(WebSocketChannel webSocketChannel) {
    channel = webSocketChannel;

    try {
      onOpen?.call(this);

      channel.stream.listen(
        (dynamic data) {
          onMessage?.call(this, data);
        },
        onDone: () {
          onClose?.call(this);
        },
        onError: (dynamic error) {
          onError?.call(this, error);
        },
      );
    } catch (e) {
      onError?.call(this, e);
      try {
        channel.sink.close();
      } catch (_) {}
    }
  }

  void send(dynamic data) => channel.sink.add(data);
}
