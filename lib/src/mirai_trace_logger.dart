import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/utils/mirai_trace_debug_io.dart'
    as log_output;
import 'package:mirai_trace_logger/src/utils/mirai_trace_release_io.dart'
    as log_output_release;

class MiraiTraceLogger {
  MiraiTraceLogger({
    DefaultSettings? settings,
    this.formatter = const LineStyleLogger(),
    LoggerFilter? filter,
    void Function(String message)? output,
    void Function(String message)? outputRelease,
  }) {
    this.settings = settings ?? DefaultSettings();

    _output = output ?? log_output.outputLog;
    _outputRelease = outputRelease ?? log_output_release.outputLogRelease;

    _filter = filter ?? LogTypeilter(this.settings.type);
    ansiColorDisabled = false;
  }

  late final DefaultSettings settings;

  final LineStyleLogger formatter;

  late final void Function(String message) _output;

  late final void Function(String message) _outputRelease;
  late final LoggerFilter _filter;

  void log(
    dynamic msg, {
    dynamic header,
    LogTypeEntity? level,
    AnsiPen? color,
    StackTrace? stackTrx,
    bool? forceLogs,
  }) {
    final selectedLevel = level ?? LogTypeEntity.debug;
    final selectedColor =
        color ?? settings.colors[selectedLevel] ?? (AnsiPen()..gray());

    if (_filter.shouldLog(settings.type) && settings.forceLogs == false) {
      final formattedMsg = formatter.formater(
        LogEntity(
          message: msg,
          header: header,
          level: selectedLevel,
          color: selectedColor,
          stack: stackTrx,
        ),
        settings,
      );
      _output(formattedMsg);
    }
    if (_filter.shouldLog(settings.type) && settings.forceLogs == true) {
      final formattedMsg = formatter.formater(
        LogEntity(
          message: msg,
          header: header,
          level: selectedLevel,
          color: selectedColor,
          stack: stackTrx,
        ),
        settings,
      );
      _outputRelease(formattedMsg);
    }

    if (!_filter.shouldLog(settings.type) && settings.forceLogs == true) {
      final formattedMsg = formatter.formater(
        LogEntity(
            message: msg,
            header: header,
            level: selectedLevel,
            color: selectedColor,
            stack: stackTrx),
        settings,
      );
      _outputRelease(formattedMsg);
    }
  }

  void critical(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.critical);

  void error(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.error);

  void warning(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.warning);

  void debug(dynamic msg, {dynamic header}) => log(msg, header: header);

  void info(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.info);

  void success(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.success);

  void stackTrx(StackTrace stack, {dynamic header}) =>
      log("", stackTrx: stack, header: header, level: LogTypeEntity.stacktrace);

  MiraiTraceLogger copyWith({
    DefaultSettings? settings,
    LineStyleLogger? formatter,
    LoggerFilter? filter,
    Function(String message)? output,
    Function(String message)? outputRelease,
  }) {
    return MiraiTraceLogger(
      settings: settings ?? this.settings,
      formatter: formatter ?? this.formatter,
      filter: filter ?? _filter,
      output: output ?? _output,
      outputRelease: outputRelease ?? _outputRelease,
    );
  }
}
