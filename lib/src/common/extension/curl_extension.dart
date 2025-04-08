import 'dart:convert' show jsonEncode;

import 'package:dio/dio.dart' show RequestOptions, FormData;

/// Extension on [RequestOptions] to convert to a curl command string.
///
/// Example:
/// ```shell
/// curl -X 'GET' \
/// 	 'https://jsonplaceholder.typicode.com/posts?test=1'
// ```
extension CurlExtension on RequestOptions {
  /// Convert the request options to a complete curl command string
  String toCurlString() {
    final curl = StringBuffer("curl -X '$method'")..write(" \\\n\t '${uri.toString()}'");

    // Add all headers
    headers.forEach((k, v) {
      if (k != 'Cookie') {
        curl.write(" \\\n\t  -H '$k: $v'");
      }
    });

    // check have data
    if (data == null) return '```shell\n$curl\n```';

    // FormData can't be JSON-serialized, so keep only their fields attributes
    if (data is FormData) {
      data = Map.fromEntries((data as FormData).fields);
    }

    curl.write(" \\\n\t  -d '${jsonEncode(data)}'");

    return '```shell\n$curl\n```';
  }

  /// Convert to a single line curl command (for logging/copying)
  String toCompactCurlString() => toCurlString().replaceAll(' \\\n\t  ', ' ');
}
