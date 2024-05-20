/// Level of logs to segmentation фтв control logging output
enum LogTypeEntity {
  /// Errors
  error,
  critical,

  /// Messages
  info,
  debug,
  warning,
}

/// List of levels sorted by priority
final logLevelPriorityList = [
  LogTypeEntity.critical,
  LogTypeEntity.error,
  LogTypeEntity.warning,
  LogTypeEntity.info,
  LogTypeEntity.debug,
];
