/// Level of logs to segmentation фтв control logging output
enum LogTypeEntity {
  error,
  critical,
  info,
  debug,
  warning,
  stacktrace,
  success,
  httpResponse,
  httpRequest,
  httpError
}

final logTypePriorityList = [
  LogTypeEntity.httpResponse,
  LogTypeEntity.httpRequest,
  LogTypeEntity.httpError,
  LogTypeEntity.stacktrace,
  LogTypeEntity.success,
  LogTypeEntity.critical,
  LogTypeEntity.error,
  LogTypeEntity.warning,
  LogTypeEntity.info,
  LogTypeEntity.debug,
];
