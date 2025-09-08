import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

class Logger {
  static const String _tag = 'AroundYou';
  
  // Singleton pattern
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();
  
  /// Log debug messages
  static void debug(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Log info messages
  static void info(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Log warning messages
  static void warning(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Log error messages
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Log critical messages
  static void critical(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.critical, message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Internal logging method
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!AppConfig.enableLogging && !kDebugMode) return;
    
    final String logTag = tag ?? _tag;
    final String timestamp = DateTime.now().toIso8601String();
    final String levelString = level.name.toUpperCase();
    
    String logMessage = '[$timestamp] [$levelString] [$logTag] $message';
    
    if (error != null) {
      logMessage += '\nError: $error';
    }
    
    if (stackTrace != null) {
      logMessage += '\nStackTrace: $stackTrace';
    }
    
    // Use developer.log for better performance and filtering
    developer.log(
      logMessage,
      name: logTag,
      level: _getLevelValue(level),
      error: error,
      stackTrace: stackTrace,
    );
    
    // In debug mode, also print to console for easier debugging
    if (kDebugMode) {
      print(logMessage);
    }
    
    // Send to crash reporting service in production
    if (AppConfig.enableCrashReporting && level == LogLevel.critical) {
      _sendToCrashlytics(message, error, stackTrace);
    }
  }
  
  /// Get numeric value for log level
  static int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 700;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.critical:
        return 1200;
    }
  }
  
  /// Send critical errors to crash reporting service
  static void _sendToCrashlytics(String message, Object? error, StackTrace? stackTrace) {
    // Implement crash reporting integration here
    // e.g., Firebase Crashlytics, Sentry, etc.
    if (kDebugMode) {
      print('🔥 CRITICAL ERROR would be sent to Crashlytics: $message');
    }
  }
  
  /// Log network requests
  static void networkRequest(String method, String url, {Map<String, dynamic>? data}) {
    if (!AppConfig.enableLogging) return;
    
    String message = '$method $url';
    if (data != null) {
      message += '\nData: $data';
    }
    
    debug(message, tag: 'NETWORK');
  }
  
  /// Log network responses
  static void networkResponse(int statusCode, String url, {dynamic data, Duration? duration}) {
    if (!AppConfig.enableLogging) return;
    
    String message = '$statusCode $url';
    if (duration != null) {
      message += ' (${duration.inMilliseconds}ms)';
    }
    if (data != null) {
      message += '\nResponse: $data';
    }
    
    final LogLevel level = statusCode >= 400 ? LogLevel.error : LogLevel.debug;
    _log(level, message, tag: 'NETWORK');
  }
  
  /// Log navigation events
  static void navigation(String from, String to, {Map<String, dynamic>? arguments}) {
    if (!AppConfig.enableLogging) return;
    
    String message = 'Navigation: $from → $to';
    if (arguments != null && arguments.isNotEmpty) {
      message += '\nArguments: $arguments';
    }
    
    debug(message, tag: 'NAVIGATION');
  }
  
  /// Log user actions
  static void userAction(String action, {Map<String, dynamic>? context}) {
    if (!AppConfig.enableLogging) return;
    
    String message = 'User Action: $action';
    if (context != null && context.isNotEmpty) {
      message += '\nContext: $context';
    }
    
    info(message, tag: 'USER_ACTION');
  }
  
  /// Log performance metrics
  static void performance(String operation, Duration duration, {Map<String, dynamic>? metrics}) {
    if (!AppConfig.enableLogging) return;
    
    String message = 'Performance: $operation took ${duration.inMilliseconds}ms';
    if (metrics != null && metrics.isNotEmpty) {
      message += '\nMetrics: $metrics';
    }
    
    final LogLevel level = duration.inMilliseconds > 1000 ? LogLevel.warning : LogLevel.debug;
    _log(level, message, tag: 'PERFORMANCE');
  }
}

/// Extension for easier logging from any class
extension LoggerExtension on Object {
  void logDebug(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.debug(message, tag: runtimeType.toString(), error: error, stackTrace: stackTrace);
  }
  
  void logInfo(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.info(message, tag: runtimeType.toString(), error: error, stackTrace: stackTrace);
  }
  
  void logWarning(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.warning(message, tag: runtimeType.toString(), error: error, stackTrace: stackTrace);
  }
  
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.error(message, tag: runtimeType.toString(), error: error, stackTrace: stackTrace);
  }
  
  void logCritical(String message, {Object? error, StackTrace? stackTrace}) {
    Logger.critical(message, tag: runtimeType.toString(), error: error, stackTrace: stackTrace);
  }
}