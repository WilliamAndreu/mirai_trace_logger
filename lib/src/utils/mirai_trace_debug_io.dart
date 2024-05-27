import 'dart:async';
import 'dart:collection';
import 'dart:developer';

Queue<String> _logQueue = Queue<String>();
Completer<void>? _completer;

Future<void> outputLog(String message) async {
  log(message);
}
@Deprecated('Will be deleted in future releases')
Future<void> _processQueue() async {
  if (_completer != null) {
    await _completer!.future;
    return;
  }

  _completer = Completer<void>();
  while (_logQueue.isNotEmpty) {
    final line = _logQueue.removeFirst();
    log(line);
    await Future.delayed(const Duration(milliseconds: 15));
  }
  _completer!.complete();
  _completer = null;
}
