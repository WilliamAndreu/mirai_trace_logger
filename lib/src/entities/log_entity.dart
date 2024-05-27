import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/entities/mirai_http_request.dart';

class LogEntity {
  const LogEntity(
      {this.header,
      required this.message,
      required this.level,
      required this.color,
      this.stack,
      this.httpRequest,
      this.httpResponse,
      this.httpError});

  final dynamic header;

  final dynamic message;

  final LogTypeEntity level;

  final AnsiPen color;
  final StackTrace? stack;
  final MiraiHttpError? httpError;
  final MiraiHttpRequest? httpRequest;
  final MiraiHttpResponse?  httpResponse;
}
