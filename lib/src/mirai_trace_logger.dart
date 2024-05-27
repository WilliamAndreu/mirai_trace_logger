import 'dart:io';

import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/entities/mirai_http_request.dart';
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
    MiraiHttpRequest? httpRequest,
    MiraiHttpResponse? httpResponse,
    MiraiHttpError? httpError,
    bool? forceLogs,
  }) {
    final selectedLevel = level ?? LogTypeEntity.debug;
    final selectedColor =
        color ?? settings.colors[selectedLevel] ?? (AnsiPen()..gray());
    final shouldLog = _filter.shouldLog(settings.type);
    final forceLogs = settings.forceLogs;

    if (shouldLog || forceLogs) {
      final logEntity = LogEntity(
        message: msg,
        header: header,
        level: selectedLevel,
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

  void critical(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.critical);

  void error(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.error);

  void warning(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.warning);

  void debug(dynamic msg, {dynamic header}) => log(msg, header: header);

  void info(dynamic msg, {dynamic header}) =>
      log(msg, header: header, level: LogTypeEntity.info);

  void success(dynamic msg, {dynamic header}) => log(
        msg,
        header: header,
        level: LogTypeEntity.success,
      );

  void stackTrx(StackTrace stack, {dynamic header}) => log(
        "",
        stackTrx: stack,
        header: header,
        level: LogTypeEntity.stacktrace,
      );

  void httpRequest(MiraiHttpRequest request, {dynamic header}) => log(
        "",
        header: header,
        level: LogTypeEntity.httpRequest,
        httpRequest: request,
      );

  void httpResponse(MiraiHttpResponse response, {dynamic header}) => log(
        "",
        header: header,
        level: LogTypeEntity.httpResponse,
        httpResponse: response,
      );

  void httpError(MiraiHttpError httpError, {dynamic header}) => log(
        "",
        header: header,
        level: LogTypeEntity.httpError,
        httpError: httpError,
      );

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
