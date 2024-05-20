import 'package:mirai_trace_logger/mirai_logger.dart';

abstract class StyleSource {
  String formater(LogEntity details, DefaultSettings settings);
}
