String formatNumToMoney(num number) {
  String formatted;
  if (number >= 1e9) {
    formatted = (number / 1e9).toStringAsFixed(1);
    return formatted.endsWith('.0') ? '${formatted.substring(0, formatted.length - 2)}B' : '${formatted}B';
  } else if (number >= 1e6) {
    formatted = (number / 1e6).toStringAsFixed(1);
    return formatted.endsWith('.0') ? '${formatted.substring(0, formatted.length - 2)}M' : '${formatted}M';
  } else if (number >= 1e3) {
    formatted = (number / 1e3).toStringAsFixed(1);
    return formatted.endsWith('.0') ? '${formatted.substring(0, formatted.length - 2)}K' : '${formatted}K';
  } else {
    return number.toString();
  }
}
