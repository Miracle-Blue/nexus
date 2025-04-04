import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../nexus.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/nexus_animation_controller.dart';
import '../../common/utils/nexus_interceptor.dart';

abstract class NexusOverlayController extends State<Nexus> with SingleTickerProviderStateMixin {
  late final NexusToolsController controller;
  double handleWidth = 16;
  bool dismissed = true;
  final List<NexusNetworkLog> networkLogs = [];
  final Map<Dio, NexusInterceptor> _interceptors = {};
  @override
  void initState() {
    super.initState();
    controller = NexusToolsController(value: 0, duration: widget.duration, vsync: this);
    controller.addStatusListener(_onStatusChanged);
    _onStatusChanged(controller.status);
    _setupInterceptors();
  }

  @override
  void didUpdateWidget(covariant Nexus oldWidget) {
    if (widget.enable) {
      dismissed = controller.status == AnimationStatus.dismissed;
    } else {
      dismissed = true;
    }
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }
    // Check for changes in the Dio instances
    if (!_listEquals(widget.dio, oldWidget.dio)) {
      _setupInterceptors();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_onStatusChanged)
      ..dispose();

    // Remove all interceptors
    for (final dio in widget.dio) {
      // ignore: prefer_foreach
      for (final interceptor in _interceptors.values) {
        dio.interceptors.remove(interceptor);
      }
    }

    _interceptors.clear();

    super.dispose();
  }

  void _setupInterceptors() {
    for (final interceptor in _interceptors.values) {
      for (final dio in widget.dio) {
        dio.interceptors.remove(interceptor);
      }
    }
    _interceptors.clear();

    // Add new interceptors
    for (final dio in widget.dio) {
      final interceptor = NexusInterceptor(onNetworkActivity: _onNetworkActivity);
      dio.interceptors.add(interceptor);
      _interceptors[dio] = interceptor;
    }
  }

  void _onNetworkActivity(NexusNetworkLog log) {
    if (!mounted) return;

    setState(() {
      // Try to find an existing log entry for this request
      final index = networkLogs.indexWhere(
        (existingLog) =>
            existingLog.request.uri.toString() == log.request.uri.toString() &&
            existingLog.request.method == log.request.method &&
            existingLog.isLoading == true &&
            log.isLoading == false,
      );

      if (index >= 0 && (log.response != null || log.error != null)) {
        // Update existing log
        networkLogs[index] = log;
      } else {
        // Add new log
        networkLogs.add(log);

        // Limit the number of logs to avoid memory issues
        if (networkLogs.length > 100) networkLogs.removeAt(0);
      }
    });
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }

  void _onStatusChanged(AnimationStatus status) {
    if (!mounted) return;
    switch (status) {
      case AnimationStatus.dismissed:
        if (dismissed) return;
        setState(() => dismissed = true);
      default:
        if (!dismissed) return;
        setState(() => dismissed = false);
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    if (dismissed) return;

    final delta = details.delta.dx;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    if (dismissed && (isRtl ? delta < 0 : delta > 0) || !dismissed && (isRtl ? delta > 0 : delta < 0)) {
      final newValue = controller.value + delta / width * (isRtl ? -1 : 1);
      controller.value = newValue.clamp(0.0, 1.0);
    }

    if (dismissed && (isLtr ? delta < 0 : delta > 0) || !dismissed && (isLtr ? delta > 0 : delta < 0)) {
      final newValue = controller.value - delta / width * (isLtr ? -1 : 1);
      controller.value = newValue.clamp(0.0, 1.0);
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (dismissed) return;

    final velocity = details.primaryVelocity ?? 0;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if ((isRtl ? -velocity : velocity) > 300 || controller.value > 0.5) {
      controller.show();
    } else {
      controller.hide();
    }
  }

  void onRemoveLogsTap() => setState(networkLogs.clear);
}
