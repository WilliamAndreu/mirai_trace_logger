import 'dart:convert';

import 'package:mirai_trace_logger/mirai_logger.dart';

void main() {
  final logger = MiraiTraceLogger(
    settings: DefaultSettings(
      type: LogTypeEntity.debug,
    ),
  );

  logger.debug('debug');
  logger.info('info');
  logger.warning('warning', header: 'test 2');
  logger.error('error');
  logger.critical('type');
  logger.log(
    'log with level info',
    header: 'test 6',
    level: LogTypeEntity.error,
  );
  logger.log('custom pen log ', header: 'test 7', color: AnsiPen()..xterm(49));

  final formatedData = convertStringFormat({
    "id": 1,
    "title": "iPhone 9",
    "description": "An apple mobile which is nothing like apple",
    "price": 549,
    "discountPercentage": 12.96,
    "rating": 4.69,
    "stock": 94,
    "brand": "Apple",
    "category": "smartphones",
    "thumbnail": "...",
    "images": ["...", "...", "..."],
  });
  logger.log(formatedData, level: LogTypeEntity.error);
}

String convertStringFormat(dynamic object) {
  const encoder = JsonEncoder.withIndent('  ');
  final formatedData = encoder.convert(object);
  return formatedData;
}
