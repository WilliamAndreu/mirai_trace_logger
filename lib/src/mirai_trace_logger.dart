
import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/utils/mirai_trace_debug_io.dart'
    as log_output;
import 'package:mirai_trace_logger/src/utils/mirai_trace_release_io.dart'
    as log_output_release;

class MiraiTraceLogger {
  MiraiTraceLogger(
      {MiraiSettings? settings,
      this.formatter = const LineStyleLogger(),
      LoggerFilter? filter,}) {
    this.settings = settings ?? MiraiSettings();
    _output = log_output.outputLog;
    _outputRelease = log_output_release.outputLogRelease;
    _filter = filter ?? LogTypeilter(this.settings.type);
    ansiColorDisabled = false;
  }

  late final MiraiSettings settings;

  final LineStyleLogger formatter;

  late final void Function(String message) _output;

  late final void Function(String message) _outputRelease;
  late final LoggerFilter _filter;

  void log(
    dynamic msg, {
    String? header,
    LogTypeEntity? level,
    AnsiPen? color,
    StackTrace? stackTrx,
    MiraiHttpRequest? httpRequest,
    MiraiHttpResponse? httpResponse,
    MiraiHttpError? httpError,
    bool? forceLogs,
  }) {
    final selectedType = level ?? LogTypeEntity.debug;
    final selectedColor =
        color ?? settings.colors[selectedType] ?? (AnsiPen()..gray());
    final shouldLog = _filter.shouldLog(selectedType);
    final forceLogs = settings.forceLogs;

    if (shouldLog || forceLogs) {
      final logEntity = LogEntity(
        message: msg,
        header: header,
        type: selectedType,
        color: selectedColor,
        stack: stackTrx,
        httpError: httpError,
        httpResponse: httpResponse,
        httpRequest: httpRequest,
      );

      final formattedMsg = formatter.formater(logEntity, settings);
      if (forceLogs) {
        _outputRelease(formattedMsg);
      } else {
        _output(formattedMsg);
      }
    }
  }

  void critical(dynamic msg, {String? header}) =>
      log(msg, header: header, level: LogTypeEntity.critical);

  void error(dynamic msg, {String? header}) =>
      log(msg, header: header, level: LogTypeEntity.error);

  void warning(dynamic msg, {String? header}) =>
      log(msg, header: header, level: LogTypeEntity.warning);

  void debug(dynamic msg, {String? header}) => log(msg, header: header);

  void info(dynamic msg, {String? header}) =>
      log(msg, header: header, level: LogTypeEntity.info);

  void success(dynamic msg, {String? header}) => log(
        msg,
        header: header,
        level: LogTypeEntity.success,
      );

  void stackTrx(StackTrace stack, {String? header}) => log(
        "",
        stackTrx: stack,
        header: header,
        level: LogTypeEntity.stacktrace,
      );

  void httpRequest(MiraiHttpRequest request) => log(
        "",
        header: 'Dio Interceptor Request',
        level: LogTypeEntity.httpRequest,
        httpRequest: request,
      );

  void httpResponse(MiraiHttpResponse response) => log(
        "",
        header: 'Dio Interceptor Response',
        level: LogTypeEntity.httpResponse,
        httpResponse: response,
      );

  void httpError(MiraiHttpError httpError) => log(
        "",
        header: 'Dio Interceptor Error',
        level: LogTypeEntity.httpError,
        httpError: httpError,
      );

  MiraiTraceLogger copyWith({
    MiraiSettings? settings,
    LineStyleLogger? formatter,
    LoggerFilter? filter,
    Function(String message)? output,
    Function(String message)? outputRelease,
  }) {
    return MiraiTraceLogger(
        settings: settings ?? this.settings,
        formatter: formatter ?? this.formatter,
        filter: filter ?? _filter,);
  }
}
