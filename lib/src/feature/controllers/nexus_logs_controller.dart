import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/models/nexus_network_log.dart';
import '../../common/utils/nexus_interceptor.dart';
import '../overlays/sort_by_alert_dialog.dart';
import '../screens/nexus_logs_screen.dart';

abstract class NexusLogsController extends State<NexusLogsScreen> {
  SortType sortType = SortType.createTime;
  final List<NexusNetworkLog> networkLogs = <NexusNetworkLog>[];
  final Map<Dio, NexusInterceptor> _interceptors = <Dio, NexusInterceptor>{};

  @override
  void initState() {
    super.initState();
    _setupInterceptors();
  }

  @override
  void didUpdateWidget(covariant NexusLogsScreen oldWidget) {
    // Check for changes in the Dio instances
    if (!_listEquals(widget.dios, oldWidget.dios)) {
      _setupInterceptors();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // Remove all interceptors
    for (final dio in widget.dios) {
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
      for (final dio in widget.dios) {
        dio.interceptors.remove(interceptor);
      }
    }
    _interceptors.clear();

    // Add new interceptors
    for (final dio in widget.dios) {
      final interceptor = NexusInterceptor(onNetworkActivity: _onNetworkActivity);
      dio.interceptors.add(interceptor);
      _interceptors[dio] = interceptor;
    }
  }

  void _onNetworkActivity(NexusNetworkLog log) => setState(() {
    final index = networkLogs.indexWhere((existingLog) => existingLog.id == log.id);

    if (index >= 0) {
      networkLogs[index] = log;
    } else {
      networkLogs.add(log);
    }
  });

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) if (a[i] != b[i]) return false;

    return true;
  }

  void onOperationTypeSelected(OperationType operationType) => switch (operationType) {
    OperationType.sort => () async {
      final result = await showSortByAlertDialog(context, sortType: sortType);
      log('result: $result');
      if (result != null) sortType = result;

      setState(() {
        if (sortType.isCreateTime) {
          networkLogs.sort((a, b) => a.sendTime?.compareTo(b.sendTime ?? DateTime.now()) ?? 0);
        } else if (sortType.isResponseTime) {
          networkLogs.sort((a, b) => a.duration?.compareTo(b.duration ?? Duration.zero) ?? 0);
        } else if (sortType.isEndpoint) {
          networkLogs.sort((a, b) => a.request.path.compareTo(b.request.path));
        }
      });
    }(),
    OperationType.delete => setState(networkLogs.clear),
  };
}

enum OperationType { sort, delete }
