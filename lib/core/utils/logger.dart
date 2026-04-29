/// Simple logging utility for the application
/// Provides structured logging without adding external dependencies
class AppLogger {
  static const String _prefix = '[FruitApp]';

  /// Log debug message
  static void debug(String message) {
    print('$_prefix [DEBUG] $message');
  }

  /// Log info message
  static void info(String message) {
    print('$_prefix [INFO] $message');
  }

  /// Log warning message
  static void warning(String message) {
    print('$_prefix [WARNING] $message');
  }

  /// Log error message
  static void error(
    String message, [
    Object? exception,
    StackTrace? stackTrace,
  ]) {
    print('$_prefix [ERROR] $message');
    if (exception != null) {
      print('Exception: $exception');
    }
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }
}
