import 'package:mirai_trace_logger/mirai_logger.dart';

abstract class LoggerFilter {
  bool shouldLog(LogTypeEntity level);
}
