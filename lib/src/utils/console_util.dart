abstract class ConsoleUtil {
  ConsoleUtil._();

  static String getline(
    int length, {
    String lineSymbol = '',
  }) {
    final line = lineSymbol * length;
    return line;
  }
}
