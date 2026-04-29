import 'dart:async';

/// Debounce utility for delaying function execution
/// Useful for search, resize events, etc.
class Debouncer {
  Timer? _timer;
  final int milliseconds;

  Debouncer({this.milliseconds = 500});

  /// Run a function with debounce
  /// The function will only execute after [milliseconds] without any new calls
  void run(Function action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () => action());
  }

  /// Cancel any pending execution
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose and clean up resources
  void dispose() {
    _timer?.cancel();
  }
}
