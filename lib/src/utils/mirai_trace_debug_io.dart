import 'dart:developer';

void outputLog(String message) {
  final StringBuffer buffer = StringBuffer();
  message.split('\n').forEach(buffer.writeln);
  log(buffer.toString());
}
