import 'package:mirai_trace_logger/mirai_logger.dart';

final _defaultColors = {
  LogTypeEntity.critical: AnsiPen()..red(),
  LogTypeEntity.error: AnsiPen()..red(),
  LogTypeEntity.warning: AnsiPen()..yellow(),
  LogTypeEntity.info: AnsiPen()..blue(),
  LogTypeEntity.debug: AnsiPen()..gray(),
    LogTypeEntity.success: AnsiPen()..green(),
};

class DefaultSettings {
  DefaultSettings(
      {Map<LogTypeEntity, AnsiPen>? colors,
      this.type = LogTypeEntity.info,
      this.lineSymbol = '─',
      this.maxLineWidth = 70,
      this.showLines = true,
       this.showHeaders = true,}) {
    if (colors != null) {
      _defaultColors.addAll(colors);
    }
    this.colors.addAll(_defaultColors);
  }

  final Map<LogTypeEntity, AnsiPen> colors = _defaultColors;

  final LogTypeEntity type;

  final String lineSymbol;

  final int maxLineWidth;

  final bool showLines;
  final bool showHeaders;

  DefaultSettings copyWith({
    Map<LogTypeEntity, AnsiPen>? colors,
    LogTypeEntity? type,
    String? lineSymbol,
    int? maxLineWidth,
    bool? showLines,
    bool? showHeaders,
  }) {
    return DefaultSettings(
        colors: colors ?? this.colors,
        type: type ?? this.type,
        lineSymbol: lineSymbol ?? this.lineSymbol,
        maxLineWidth: maxLineWidth ?? this.maxLineWidth,
        showLines: showLines ?? this.showLines,
        showHeaders: showHeaders ?? this.showHeaders);
  }
}
