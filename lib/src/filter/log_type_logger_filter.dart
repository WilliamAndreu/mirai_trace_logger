import 'package:mirai_trace_logger/mirai_logger.dart';

class LogTypeilter implements LoggerFilter {
  const LogTypeilter(this.logLevel);

  final LogTypeEntity logLevel;

  @override
  bool shouldLog(LogTypeEntity level) {
    final currLogLevelIndex = logTypePriorityList.indexOf(logLevel);
    final msgLogLevelIndex = logTypePriorityList.indexOf(level);
    return currLogLevelIndex >= msgLogLevelIndex;
  }
}
