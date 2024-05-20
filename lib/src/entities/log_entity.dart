import 'package:mirai_trace_logger/mirai_logger.dart';

/// A class for transporting data
/// about an log message
class LogEntity {
  const LogEntity({
    this.header,
    required this.message,
    required this.level,
    required this.color,
    this.stack,
  });

  final dynamic header;

  final dynamic message;

  final LogTypeEntity level;

  final AnsiPen color;

  final dynamic stack;
}
