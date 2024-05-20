import 'package:mirai_trace_logger/mirai_logger.dart';

class LineStyleLogger implements StyleSource {
  const LineStyleLogger();

  @override
  String formater(LogEntity details, DefaultSettings settings) {
    final underline = ConsoleUtil.getline(settings.maxLineWidth,
        lineSymbol: settings.lineSymbol);

    final header =
        details.header == null ? '' : '[${details.header?.toString()}]';
    final headerBorderedLines = header.split('\n').map((e) => e);
    final msg = details.message != null ? '${details.message}' : '';
    final msgBorderedLines = msg.split('\n').map((e) => '  ${e}');

List<String> lines;
if (settings.showHeaders && header.isNotEmpty) {
  lines = settings.showLines
    ? [...headerBorderedLines, underline, ...msgBorderedLines, underline]
    : [...headerBorderedLines, ...msgBorderedLines];
} else {
  lines = settings.showLines
    ? [underline, ...msgBorderedLines, underline]
    : [...msgBorderedLines];
}
    lines = lines.map((e) => details.pen.write(e)).toList();
    final coloredMsg = lines.join('\n');
    return coloredMsg;
  }
}
