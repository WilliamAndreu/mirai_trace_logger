import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/utils/mirai_trace_io.dart' as log_output;

class MiraiTraceLogger {
  MiraiTraceLogger({
    DefaultSettings? settings,
    this.formatter = const LineStyleLogger(),
    LoggerFilter? filter,
    void Function(String message)? output,
  }) {
    this.settings = settings ?? DefaultSettings();
    
    _output = output ?? log_output.outputLog;
    _filter = filter ?? LogTypeilter(this.settings.type);
    ansiColorDisabled = false;
  }

  late final DefaultSettings settings;

  final LineStyleLogger formatter;

  late final void Function(String message) _output;
  late final LoggerFilter _filter;

  void log(dynamic msg, {dynamic header, LogTypeEntity? level, AnsiPen? color, StackTrace? stack}) {
    final selectedLevel = level ?? LogTypeEntity.debug;
    final selectedColor =
        color ?? settings.colors[selectedLevel] ?? (AnsiPen()..gray());

    if (_filter.shouldLog(selectedLevel)) {
      final formattedMsg = formatter.formater(
        LogEntity(
            message: msg,
            header: header,
            level: selectedLevel,
            color: selectedColor,
            stack: stack),
        settings,
      );
      _output(formattedMsg);
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
      log(stack, header: header);

  MiraiTraceLogger copyWith({
    DefaultSettings? settings,
    LineStyleLogger? formatter,
    LoggerFilter? filter,
    Function(String message)? output,
  }) {
    return MiraiTraceLogger(
      settings: settings ?? this.settings,
      formatter: formatter ?? this.formatter,
      filter: filter ?? _filter,
      output: output ?? _output,
    );
  }
}
