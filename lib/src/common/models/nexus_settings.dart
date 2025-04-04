import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final class NexusSettings {
  const NexusSettings({
    required this.child,
    this.dio = const <Dio>[],
    this.enable = kDebugMode,
    this.duration = const Duration(milliseconds: 250),
  });

  final bool enable;
  final Duration duration;
  final List<Dio> dio;
  final Widget child;
}
