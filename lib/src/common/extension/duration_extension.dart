extension DurationX on Duration? {
  String get formatCompactDuration {
    if (this == null) return '';

    final seconds = (this?.inMilliseconds ?? 1) / 1000;

    return '${seconds.toStringAsFixed(2)}s';
  }
}
