import 'dart:developer';

void outputLog(String message) => message.split('\n').forEach((value) {
      log(value);
    });
