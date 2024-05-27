import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/entities/mirai_http_request.dart';
import 'package:mirai_trace_logger/src/entities/stacktrace_entity.dart';

class LineStyleLogger implements StyleSource {
  const LineStyleLogger();

  @override
  String formater(LogEntity details, DefaultSettings settings) {
    final header = _formatHeader(details.header);
    final message = _formatMessage(details.message);
    final isStackTrace = details.level == LogTypeEntity.stacktrace;
    final isHttpResponse = details.level == LogTypeEntity.httpResponse;
    final isHttpRequest = details.level == LogTypeEntity.httpRequest;
    final isHttpError = details.level == LogTypeEntity.httpError;

    final stackTrace = isStackTrace && details.stack != null
        ? _formatStackTrace(details.stack!)
        : '';
    final httpError = isHttpError && details.httpError != null
        ? _formatHttpError(details.httpError!)
        : '';
    final httpResponse = isHttpResponse && details.httpResponse != null
        ? _formatHttpResponse(details.httpResponse!)
        : '';

    final httpRequest = isHttpRequest && details.httpRequest != null
        ? _formatHttpRequest(details.httpRequest!)
        : '';

    final lines = _buildLines(
        header,
        message.toString(),
        stackTrace,
        settings,
        isStackTrace,
        isHttpResponse,
        isHttpRequest,
        isHttpError,
        httpResponse,
        httpError,
        httpRequest);

    final coloredLines = lines.map(details.color.write).toList();
    return coloredLines.join('\n');
  }

  String _formatHeader(header) {
    return header == null ? '' : '[${header}]';
  }

  dynamic _formatMessage(message) {
    return message ?? '';
  }

  List<String> _buildLines(
    String header,
    String message,
    String stackTrace,
    DefaultSettings settings,
    bool isStackTrace,
    bool isHttpResponse,
    bool isHttpRequest,
    bool isHttpError,
    String httpResponse,
    String httpError,
    String httpRequest,
  ) {
    final headerMessage = header.split('\n');
    final messageLines = message.split('\n').map((line) => '  $line').toList();
    final httpRequestLines =
        httpRequest.split('\n').map((line) => '  $line').toList();
    final httpResponseLines =
        httpResponse.split('\n').map((line) => '  $line').toList();
    final httpErrorLines =
        httpError.split('\n').map((line) => '  $line').toList();

    final stackLines = stackTrace.split('\n').map((line) => '  $line').toList();
    final headerline = ConsoleUtil.getline(settings.maxLineWidth,
        lineSymbol: settings.lineSymbol);
    final buttonLine = ConsoleUtil.getBottonLine(settings.maxLineWidth,
        lineSymbol: settings.lineSymbol);

    if (settings.showHeaders && header.isNotEmpty && header != null) {
      return settings.showLines
          ? [
              ...headerMessage,
              headerline,
              if (isStackTrace)
                ...stackLines
              else if (isHttpError)
                ...httpErrorLines
              else if (isHttpResponse)
                ...httpResponseLines
              else if (isHttpRequest)
                ...httpRequestLines
              else
                ...messageLines,
              buttonLine
            ]
          : [
              ...headerMessage,
              if (isStackTrace)
                ...stackLines
              else if (isHttpError)
                ...httpErrorLines
              else if (isHttpResponse)
                ...httpResponseLines
              else if (isHttpRequest)
                ...httpRequestLines
              else
                ...messageLines
            ];
    } else {
      return settings.showLines
          ? [
              headerline,
              if (isStackTrace)
                ...stackLines
              else if (isHttpError)
                ...httpErrorLines
              else if (isHttpResponse)
                ...httpResponseLines
              else if (isHttpRequest)
                ...httpRequestLines
              else
                ...messageLines,
              buttonLine,
            ]
          : [
              if (isStackTrace)
                ...stackLines
              else if (isHttpError)
                ...httpErrorLines
              else if (isHttpResponse)
                ...httpResponseLines
              else if (isHttpRequest)
                ...httpRequestLines
              else
                ...messageLines
            ];
    }
  }

  String _formatStackTrace(StackTrace stack) {
    final stackEntity = _parseTrace(stack);
    return [
      stackEntity.fileName,
      stackEntity.functionName,
      stackEntity.callerFunctionName,
      stackEntity.lineNumber,
      stackEntity.columnNumber
    ].join('\n');
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
    final callerFunctionName = _getFunctionNameFromFrame(frames[1]);

    final traceString = frames[0];
    final fileName = _extractFileName(traceString);
    final lineNumber = _extractLineNumber(traceString);
    final columnNumber = _extractColumnNumber(traceString);

    return StacktraceEntity(
      fileName: fileName,
      functionName: functionName,
      callerFunctionName: callerFunctionName,
      lineNumber: lineNumber,
      columnNumber: columnNumber,
    );
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
}
