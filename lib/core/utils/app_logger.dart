import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('[WARNING] $message');
    }
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');

      if (error != null) {
        debugPrint(error.toString());
      }

      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }
}