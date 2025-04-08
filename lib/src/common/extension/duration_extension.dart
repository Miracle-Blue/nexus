/// Extension on [Duration] to format it as a compact duration string.
extension DurationX on Duration? {
  /// Format the duration as a compact duration string.
  ///
  /// Example:
  /// ```dart
  /// final duration = Duration(milliseconds: 1234);
  /// final compactDuration = duration.formatCompactDuration; // '1.23s'
  /// ```
  String get formatCompactDuration {
    if (this == null) return '';

    final seconds = (this?.inMilliseconds ?? 1) / 1000;

    return '${seconds.toStringAsFixed(2)}s';
  }
}
