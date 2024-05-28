import 'package:mirai_trace_logger/mirai_logger.dart';

class LogTypeilterCustom implements LoggerFilter {
  const LogTypeilterCustom(this.logLevel);

  final LogTypeEntity logLevel;

  @override
  bool shouldLog(LogTypeEntity level) {
    return true;
  }
}
