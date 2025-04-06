abstract class Helpers {
  const Helpers._();

  static const int _kilobyteAsByte = 1000;
  static const int _megabyteAsByte = 1000000;

  static String formatBytes(int? bytes) {
    if (bytes == null || bytes < 0) return '0B';

    if (bytes <= _kilobyteAsByte) return '${bytes}B';

    if (bytes <= _megabyteAsByte) return '${_formatDouble(bytes / _kilobyteAsByte)}kB';

    return '${_formatDouble(bytes / _megabyteAsByte)}MB';
  }

  static String _formatDouble(double value) => value.toStringAsFixed(2);
}
