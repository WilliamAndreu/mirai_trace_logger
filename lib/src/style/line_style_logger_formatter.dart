import 'package:mirai_trace_logger/mirai_logger.dart';
import 'package:mirai_trace_logger/src/entities/stacktrace_entity.dart';

class LineStyleLogger implements StyleSource {
  const LineStyleLogger();

  @override
  String formater(LogEntity details, DefaultSettings settings) {
    final underline = ConsoleUtil.getline(settings.maxLineWidth, lineSymbol: settings.lineSymbol);
    final header = _formatHeader(details.header);
    final message = _formatMessage(details.message);
    final isStackTrace = details.level == LogTypeEntity.stacktrace;
    
    final stackTrace = isStackTrace ? _formatStackTrace(details.stack as StackTrace) : '';
    final lines = _buildLines(header, message.toString(), stackTrace, settings, isStackTrace);
    
    final coloredLines = lines.map(details.color.write).toList();
    return coloredLines.join('\n');
  }

  String _formatHeader( header) {
    return header == null ? '' : '[${header}]';
  }


   dynamic _formatMessage( message) {
    return message ?? '';
  }

  List<String> _buildLines(String header, String message, String stackTrace, DefaultSettings settings, bool isStackTrace) {
    final headerLines = header.split('\n');
    final messageLines = message.split('\n').map((line) => '  $line').toList();
    final stackLines = stackTrace.split('\n').map((line) => '  $line').toList();
    final underline = ConsoleUtil.getline(settings.maxLineWidth, lineSymbol: settings.lineSymbol);

    if (settings.showHeaders && header.isNotEmpty) {
      return settings.showLines
          ? [...headerLines, underline, if (isStackTrace) ...stackLines else ...messageLines, underline]
          : [...headerLines, if (isStackTrace) ...stackLines else ...messageLines];
    } else {
      return settings.showLines
          ? [underline, if (isStackTrace) ...stackLines else ...messageLines, underline]
          : [if (isStackTrace) ...stackLines else ...messageLines];
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
    final functionNamePattern = RegExp(r'\b[A-Za-z0-9]+\b');
    return functionNamePattern.firstMatch(frame)?.group(0) ?? '';
  }

  String _extractFileName(String traceString) {
    final fileNamePattern = RegExp(r'[A-Za-z]+\.dart');
    return fileNamePattern.firstMatch(traceString)?.group(0) ?? '';
  }

  int _extractLineNumber(String traceString) {
    final lineNumberPattern = RegExp(r':(\d+):');
    return int.parse(lineNumberPattern.firstMatch(traceString)?.group(1) ?? '0');
  }

  int _extractColumnNumber(String traceString) {
    final columnNumberPattern = RegExp(r':\d+:(\d+)\)');
    return int.parse(columnNumberPattern.firstMatch(traceString)?.group(1) ?? '0');
  }
}
