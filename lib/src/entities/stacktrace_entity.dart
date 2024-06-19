
class StacktraceEntity {
  const StacktraceEntity(
      {required this.fileName,
      required this.functionName,
      this.callerFunctionName,
      this.lineNumber,
      this.columnNumber,});

  final String fileName;
  final String functionName;
  final String? callerFunctionName;
  final int? lineNumber;
  final int? columnNumber;
}
