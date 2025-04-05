import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../models/nexus_network_log.dart';

/// Custom Dio interceptor for Nexus
final class NexusInterceptor extends Interceptor {
  NexusInterceptor({required this.onNetworkActivity});

  final void Function(NexusNetworkLog log) onNetworkActivity;
  final Map<String, DateTime> _requestStartTimes = <String, DateTime>{};
  final Map<String, String> _requestIdMap = <String, String>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestHashCode = options.hashCode.toString();
    final logId = const Uuid().v4();

    // Store the start time
    _requestStartTimes[requestHashCode] = DateTime.now();
    // Map the request hash to the log ID
    _requestIdMap[requestHashCode] = logId;

    final log = NexusNetworkLog(id: logId, timestamp: DateTime.now(), request: options, isLoading: true);

    onNetworkActivity(log);
    handler.next(options);
  }

  @override
  void onResponse(Response<Object?> response, ResponseInterceptorHandler handler) {
    final requestHashCode = response.requestOptions.hashCode.toString();
    final startTime = _requestStartTimes[requestHashCode];
    final logId = _requestIdMap[requestHashCode];

    Duration? duration;
    if (startTime != null) {
      duration = DateTime.now().difference(startTime);
      _requestStartTimes.remove(requestHashCode);
    }

    final log = NexusNetworkLog(
      id: logId ?? const Uuid().v4(),
      timestamp: DateTime.now(),
      isLoading: false,
      request: response.requestOptions,
      response: response,
      duration: duration,
    );

    onNetworkActivity(log);
    _requestIdMap.remove(requestHashCode);

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestHashCode = err.requestOptions.hashCode.toString();
    final startTime = _requestStartTimes[requestHashCode];
    final logId = _requestIdMap[requestHashCode];

    Duration? duration;
    if (startTime != null) {
      duration = DateTime.now().difference(startTime);
      _requestStartTimes.remove(requestHashCode);
    }

    final log = NexusNetworkLog(
      id: logId ?? const Uuid().v4(),
      timestamp: DateTime.now(),
      request: err.requestOptions,
      error: err,
      duration: duration,
      isLoading: false,
    );

    onNetworkActivity(log);
    _requestIdMap.remove(requestHashCode);
    handler.next(err);
  }
}
