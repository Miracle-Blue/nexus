import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/thunder_network_log.dart';

/// Custom Dio interceptor for Thunder
final class ThunderInterceptor extends Interceptor {
  /// Factory constructor that returns the singleton instance
  factory ThunderInterceptor(
      {required void Function(ThunderNetworkLog log) onNetworkActivity}) {
    _instance._onNetworkActivity = onNetworkActivity;
    return _instance;
  }

  /// Private constructor
  ThunderInterceptor._internal();

  /// The singleton instance
  static final ThunderInterceptor _instance = ThunderInterceptor._internal();

  /// The callback to call when a network activity is detected
  late void Function(ThunderNetworkLog log) _onNetworkActivity;

  /// The map of request hash codes to their start times
  final Map<String, DateTime> _requestStartTimes = <String, DateTime>{};

  /// The map of request hash codes to their log IDs
  final Map<String, String> _requestIdMap = <String, String>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestHashCode = options.hashCode.toString();
    final logId = DateTime.now().microsecondsSinceEpoch.toString();

    // Store the start time
    _requestStartTimes[requestHashCode] = DateTime.now();

    // Map the request hash to the log ID
    _requestIdMap[requestHashCode] = logId;

    final log = ThunderNetworkLog(
      id: logId,
      sendTime: DateTime.now(),
      request: options,
      isLoading: true,
      receiveTime: null,
    );

    _onNetworkActivity(log);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    final requestHashCode = response.requestOptions.hashCode.toString();
    final startTime = _requestStartTimes[requestHashCode];
    final logId = _requestIdMap[requestHashCode];

    // Clean up the maps immediately after retrieving values
    _requestStartTimes.remove(requestHashCode);
    _requestIdMap.remove(requestHashCode);

    Duration? duration;
    if (startTime != null) {
      duration = DateTime.now().difference(startTime);
    }

    final log = ThunderNetworkLog(
      id: logId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      sendTime: startTime ?? DateTime.now(),
      receiveTime: DateTime.now(),
      isLoading: false,
      request: response.requestOptions,
      response: response,
      duration: duration,
      receiveBytes: response.data != null
          ? utf8.encode(response.data.toString()).length
          : 0,
      sendBytes: response.requestOptions.data != null
          ? utf8.encode(response.requestOptions.data.toString()).length
          : 0,
    );

    _onNetworkActivity(log);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestHashCode = err.requestOptions.hashCode.toString();
    final startTime = _requestStartTimes[requestHashCode];
    final logId = _requestIdMap[requestHashCode];

    // Clean up the maps immediately after retrieving values
    _requestStartTimes.remove(requestHashCode);
    _requestIdMap.remove(requestHashCode);

    Duration? duration;
    if (startTime != null) {
      duration = DateTime.now().difference(startTime);
    }

    final log = ThunderNetworkLog(
      id: logId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      sendTime: startTime ?? DateTime.now(),
      request: err.requestOptions,
      receiveTime: DateTime.now(),
      error: err,
      duration: duration,
      isLoading: false,
      receiveBytes: err.response?.data != null
          ? utf8.encode(err.response!.data.toString()).length
          : 0,
      sendBytes: err.requestOptions.data != null
          ? utf8.encode(err.requestOptions.data.toString()).length
          : 0,
    );

    _onNetworkActivity(log);
    handler.next(err);
  }

  /// Clear all tracked requests (useful for cleanup)
  void clearTrackedRequests() {
    _requestStartTimes.clear();
    _requestIdMap.clear();
  }
}
