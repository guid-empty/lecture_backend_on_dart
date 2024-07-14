import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

late final Logger logger;
late final String _instancePrefix;

class LoggerSettings {
  static const int separatorLength = 60;
  static File? logsFile;

  static Future<Logger> initLogging({
    Iterable<LogOutput>? outputs,
    bool useColors = true,
    String instancePrefix = '',
  }) async {
    _instancePrefix = instancePrefix;

    logger = _SHMRLogger(
      instancePrefix: _instancePrefix,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 80,
        colors: useColors,
        printEmojis: false,
        printTime: true,
        noBoxingByDefault: true,
      ),
      output: MultiOutput(
        [ConsoleOutput(), ...?outputs],
      ),
    );

    logger.info('logging is initialized, prefix is $instancePrefix');
    return logger;
  }
}

class _SHMRLogger extends Logger {
  final String instancePrefix;

  _SHMRLogger({
    required this.instancePrefix,
    super.printer,
    super.output,
  });

  @override
  void log(
    Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    super.log(
      level,
      '${instancePrefix.isNotEmpty ? '$instancePrefix: ' : ''}$message',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

extension LoggerExtension on Logger {
  void debug(dynamic message) => log(Level.debug, message);

  void info(dynamic message) => log(Level.info, message);

  void severe(dynamic message, [dynamic error, StackTrace? stackTrace]) => log(
        Level.error,
        message,
        error: error,
        stackTrace: stackTrace,
      );
}
