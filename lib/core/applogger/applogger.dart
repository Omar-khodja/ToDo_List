import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.warning : Level.trace,
    printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5, lineLength: 90),
  );

  static String _format(String message, String? className) {
    if (className == null) return message;
    return "[$className] $message";
  }

  static void d(String message, {String? className}) {
    _logger.d(_format(message, className));
  }

  static void i(String message, {String? className}) {
    _logger.i(_format(message, className));
  }

  static void w(String message, {String? className}) {
    _logger.w(_format(message, className));
  }

  static void t(String message, {String? className}) {
    _logger.t(_format(message, className)); // trace level
  }

  static void e(
    String message, {
    String? className,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      _format(message, className),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
