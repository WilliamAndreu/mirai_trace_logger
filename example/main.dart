import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/entities/mirai_http_request.dart';

void main() {
  final logger = MiraiTraceLogger(
    settings: DefaultSettings(type: LogTypeEntity.debug),
  );

  logger.debug('debug', header: 'test 1');
  logger.info('info');
  logger.warning('warning', header: 'test 2');
  logger.error('error');
  logger.critical('Critical');
  logger.success('type');
  logger.httpRequest(const MiraiHttpRequest(
      path: "/holi",
      method: "GET",
      baseUrl: "https://meloinvento/api",
      data: null,
      queryParameters: {},
      headers: {}));
  logger.httpResponse(const MiraiHttpResponse(
    statusCode: "500",
  ));
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
    logger.stackTrx(stacktrace, header: e.toString());
  }
  debugger();
}

String convertStringFormat(dynamic object) {
  const encoder = JsonEncoder.withIndent('  ');
  final formatedData = encoder.convert(object);
  return formatedData;
}

void simulateError() {
  throw Exception('Simulated exception');
}
