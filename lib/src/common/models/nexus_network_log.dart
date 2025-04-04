import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../extension/string_extension.dart';

/// Model class to store network request/response data
final class NexusNetworkLog extends Equatable {
  NexusNetworkLog({
    required this.timestamp,
    required this.request,
    required this.isLoading,
    this.response,
    this.error,
    this.duration,
    String? id,
  }) : id = id ?? const Uuid().v4();

  final DateTime timestamp;
  final RequestOptions request;
  final Response<Object?>? response;
  final DioException? error;
  final Duration? duration;
  final bool isLoading;
  final String id;

  Color get methodColor => request.method.methodColor;
  Color get methodBackgroundColor => request.method.methodBackgroundColor;

  NexusNetworkLog copyWith({
    DateTime? timestamp,
    RequestOptions? request,
    Response<Object?>? response,
    DioException? error,
    Duration? duration,
    bool? isLoading,
  }) =>
      NexusNetworkLog(
        timestamp: timestamp ?? this.timestamp,
        request: request ?? this.request,
        response: response ?? this.response,
        error: error ?? this.error,
        duration: duration ?? this.duration,
        isLoading: isLoading ?? this.isLoading,
        id: id,
      );

  @override
  List<Object?> get props => <Object?>[timestamp, request, response, error, duration, isLoading, id];

  @override
  String toString() =>
      'NexusNetworkLog(timestamp: $timestamp, request: $request, response: $response, error: $error, duration: $duration, isLoading: $isLoading, id: $id)';
}
