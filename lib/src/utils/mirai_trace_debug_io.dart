import 'dart:async';
import 'dart:developer';
import 'dart:collection';

Queue<String> _logQueue = Queue<String>();
Completer<void>? _completer;

Future<void> outputLog(String message) async {
  _logQueue.addAll(message.split('\n'));
  await _processQueue();
}

Future<void> _processQueue() async {
  if (_completer != null) {
    await _completer!.future;
    return;
  }

  _completer = Completer<void>();
  while (_logQueue.isNotEmpty) {
    final line = _logQueue.removeFirst();
    log(line);
    await Future.delayed(const Duration(milliseconds: 20));
  }
  _completer!.complete();
  _completer = null;
}
