import 'package:mirai_trace_logger/mirai_logger.dart';

class StacktraceEntity {
  const StacktraceEntity(
      {required this.fileName,
      required this.functionName,
      required this.callerFunctionName,
      required this.lineNumber,
      required this.columnNumber});

  final String fileName;
  final String functionName;
  final String callerFunctionName;
  final int lineNumber;
  final int columnNumber;
}
