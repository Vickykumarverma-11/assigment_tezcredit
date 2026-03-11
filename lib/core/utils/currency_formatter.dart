/// Formats a numeric value into Indian currency notation (e.g. ₹5,00,000).
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Returns Indian-style formatted currency string: ₹X,XX,XXX
  static String formatIndian(double value) {
    final intVal = value.round();
    if (intVal < 0) return '-${formatIndian(-value)}';

    final str = intVal.toString();
    if (str.length <= 3) return '\u20B9$str';

    final lastThree = str.substring(str.length - 3);
    final remaining = str.substring(0, str.length - 3);

    final buffer = StringBuffer();
    for (var i = 0; i < remaining.length; i++) {
      if (i > 0 && (remaining.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(remaining[i]);
    }

    return '\u20B9$buffer,$lastThree';
  }

  /// Returns short format: 50L, 5Cr, 500K, etc.
  static String formatShort(double value) {
    if (value >= 10000000) {
      return '${(value / 10000000).toStringAsFixed(2)} Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(2)} L';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)} K';
    }
    return value.toStringAsFixed(0);
  }
}
