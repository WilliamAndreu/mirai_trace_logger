import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/entities/mirai_http_request.dart';
import 'package:mirai_trace_logger/src/entities/stacktrace_entity.dart';

class LineStyleLogger implements StyleSource {
  const LineStyleLogger();

  @override
  String formater(LogEntity details, DefaultSettings settings) {
    final header = _formatHeader(details.header);
    final message = _formatMessage(details.message);
    final logTypeHandlers = _getLogTypeHandlers(details);
    final formattedLog = _formatLogLines(
      header,
      message.toString(),
      settings,
      logTypeHandlers,
    );

    return _applyColorAndJoin(formattedLog, details.color.write);
  }

  String _formatHeader(String? header) {
    return header == null ? '' : '[$header]';
  }

  dynamic _formatMessage(dynamic message) {
    return message ?? '';
  }

  Map<String, String> _getLogTypeHandlers(LogEntity details) {
    return {
      'stackTrace':
          details.level == LogTypeEntity.stacktrace && details.stack != null
              ? _formatStackTrace(details.stack!)
              : '',
      'httpError':
          details.level == LogTypeEntity.httpError && details.httpError != null
              ? _formatHttpError(details.httpError!)
              : '',
      'httpResponse': details.level == LogTypeEntity.httpResponse &&
              details.httpResponse != null
          ? _formatHttpResponse(details.httpResponse!)
          : '',
      'httpRequest': details.level == LogTypeEntity.httpRequest &&
              details.httpRequest != null
          ? _formatHttpRequest(details.httpRequest!)
          : '',
    };
  }

  List<String> _formatLogLines(
    String header,
    String message,
    DefaultSettings settings,
    Map<String, String> logTypeHandlers,
  ) {
    final messageLines = _indentLines(message.split('\n'));
    final logLines = _selectLogLines(logTypeHandlers);

    final headerLine = ConsoleUtil.getline(settings.maxLineWidth,
        lineSymbol: settings.lineSymbol);
    final footerLine = ConsoleUtil.getBottonLine(settings.maxLineWidth,
        lineSymbol: settings.lineSymbol);

    final formattedLines = [
      if (settings.showHeaders && header.isNotEmpty) header,
      if (settings.showLines) headerLine,
      ...messageLines,
      ...logLines,
      if (settings.showLines) footerLine,
    ];

    return formattedLines.where((line) => line.isNotEmpty).toList();
  }

  List<String> _selectLogLines(Map<String, String> logTypeHandlers) {
    return logTypeHandlers.values
        .expand((log) => _indentLines(log.split('\n')))
        .toList();
  }

  List<String> _indentLines(List<String> lines) {
    return lines.map((line) => line.isNotEmpty ? '  $line' : line).toList();
  }

  String _applyColorAndJoin(
      List<String> lines, String Function(String) colorWriter) {
    return lines.map(colorWriter).join('\n');
  }

  String _formatStackTrace(StackTrace stack) {
    final stackEntity = _parseTrace(stack);
    return [stackEntity.fileName, stackEntity.functionName].join('\n');
  }

  String _formatHttpError(MiraiHttpError error) {
    return " => PATH: ${error.path}\n"
        " => STATUS CODE: ${error.statusCode ?? "null"}";
  }

  String _formatHttpResponse(MiraiHttpResponse response) {
    return " => RESPONSE STATUS CODE: ${response.statusCode}\n"
        " => RESPONSE STATUS MESSAGE: ${response.statusMessage} \n"
        " => RESPONSE DATA: ${response.data}";
  }

  String _formatHttpRequest(MiraiHttpRequest request) {
    return " => BASE URL: ${request.baseUrl}\n"
        " => PATH: ${request.path}\n"
        " => DATA: ${request.data}\n"
        " => QUERY PARAMS: ${request.queryParameters}\n"
        " => HEADERS: ${request.headers}\n"
        " => RESPONSE TYPE: ${request.responseType}\n"
        " => METHOD: ${request.method}";
  }

  StacktraceEntity _parseTrace(StackTrace trace) {
    final frames = trace.toString().split('\n');
    final functionName = _getFunctionNameFromFrame(frames[0]);
    //final callerFunctionName = _getFunctionNameFromFrame(frames[1]);
    final traceString = frames[0];
    final fileName = _extractFileName(traceString);
    //final lineNumber = _extractLineNumber(traceString);
    //final columnNumber = _extractColumnNumber(traceString);

    return StacktraceEntity(
      fileName: fileName,
      functionName: functionName,
    );
  }

  String _extractFileName(String traceString) {
    final fileNamePattern = RegExp(r'[A-Za-z]+\.dart');
    return fileNamePattern.firstMatch(traceString)?.group(0) ?? '';
  }

  int _extractLineNumber(String traceString) {
    final lineNumberPattern = RegExp(r':(\d+):');
    return int.parse(
        lineNumberPattern.firstMatch(traceString)?.group(1) ?? '0');
  }

  int _extractColumnNumber(String traceString) {
    final columnNumberPattern = RegExp(r':\d+:(\d+)\)');
    return int.parse(
        columnNumberPattern.firstMatch(traceString)?.group(1) ?? '0');
  }

  String _getFunctionNameFromFrame(String frame) {
    var currentTrace = frame;
    var indexOfWhiteSpace = currentTrace.indexOf(' ');
    var subStr = currentTrace.substring(indexOfWhiteSpace);
    var indexOfFunction = subStr.indexOf(RegExp(r'[A-Za-z0-9]'));
    subStr = subStr.substring(indexOfFunction);
    indexOfWhiteSpace = subStr.indexOf(' ');
    subStr = subStr.substring(0, indexOfWhiteSpace);
    return subStr;
  }
}
