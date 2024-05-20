/// Level of logs to segmentation фтв control logging output
enum LogTypeEntity {
  error,
  critical,
  info,
  debug,
  warning,
  stacktrace,
  success
}

/// List of levels sorted by priority
final logLevelPriorityList = [
  LogTypeEntity.stacktrace,
  LogTypeEntity.success,
  LogTypeEntity.critical,
  LogTypeEntity.error,
  LogTypeEntity.warning,
  LogTypeEntity.info,
  LogTypeEntity.debug,
];
