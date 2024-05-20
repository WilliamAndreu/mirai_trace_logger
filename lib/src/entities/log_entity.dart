import 'package:mirai_trace_logger/mirai_logger.dart';

/// A class for transporting data
/// about an log message
class LogEntity {
  const LogEntity({
    this.header,
    required this.message,
    required this.level,
    required this.pen,
  });

  final dynamic header;

  /// Log message
  final dynamic message;

  /// Log [LogLevel]
  final LogTypeEntity level;

  /// Pen for colored console message
  final AnsiPen pen;
}
