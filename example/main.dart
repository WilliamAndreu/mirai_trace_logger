import 'dart:convert';

import 'package:mirai_trace_logger/mirai_logger.dart';

void main() {
  final logger = MiraiTraceLogger(
    settings: DefaultSettings(
      type: LogTypeEntity.debug,
      showLines: false,
      showHeaders: false
    ),
  );

  logger.debug('debug');
  logger.info('info');
  logger.warning('warning', header: 'test 2');
  logger.error('error');
  logger.critical('Critical');
  logger.success('type');
  logger.log(
    'log with level info',
    header: 'test 6',
    level: LogTypeEntity.error,
  );

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

  try {
    simulateError();
  } catch (e, stacktrace) {
    logger.stackTrx(stacktrace, header: e);
  }
}

String convertStringFormat(dynamic object) {
  const encoder = JsonEncoder.withIndent('  ');
  final formatedData = encoder.convert(object);
  return formatedData;
}

void simulateError() {
  throw Exception('Simulated exception');
}
