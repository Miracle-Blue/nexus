import 'dart:convert';

extension ObjectX on Object? {
  String get prettyJson => const JsonEncoder.withIndent('  ').convert(this);
}
