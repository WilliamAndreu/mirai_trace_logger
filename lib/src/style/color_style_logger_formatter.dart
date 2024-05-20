import 'package:mirai_trace_logger/mirai_logger.dart';

class ColorStyleLogger implements StyleSource {
  const ColorStyleLogger();

  @override
  String formater(LogEntity details, DefaultSettings settings) {
    final underline = ConsoleUtil.getline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
    );
    final msg = details.message?.toString() ?? '';
    var lines = msg.split('\n');
    lines = lines.map((e) => details.pen.write(e)).toList();
    lines.add(details.pen.write(underline));
    final coloredMsg = lines.join('\n');
    return coloredMsg;
  }
}
