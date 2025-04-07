import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/models/nexus_network_log.dart';
import '../../common/utils/nexus_interceptor.dart';
import '../overlays/sort_by_alert_dialog.dart';
import '../screens/nexus_logs_screen.dart';

abstract class NexusLogsController extends State<NexusLogsScreen> {
  static NexusLogsController? _instance;
  static final List<NexusNetworkLog> networkLogs = <NexusNetworkLog>[];

  final appBarHeight = 100.0;
  final Map<Dio, NexusInterceptor> _interceptors = <Dio, NexusInterceptor>{};

  @override
  void initState() {
    super.initState();
    _instance = this;
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

  static SortType sortType = SortType.createTime;
  static bool _isDialogOpen = false;

  static Future<void> onSortLogsTap() async {
    final context = _instance?.context;
    if (context == null) return;

    // Check if dialog is already open, if so, return early
    if (_isDialogOpen) {
      return Navigator.of(context, rootNavigator: true).pop();
    }

    _isDialogOpen = true;

    try {
      final result = await showSortByAlertDialog(context, sortType: sortType);

      if (result != null) sortType = result;

      _instance?.setState(() {
        if (sortType.isCreateTime) {
          networkLogs.sort((a, b) => a.sendTime?.compareTo(b.sendTime ?? DateTime.now()) ?? 0);
        } else if (sortType.isResponseTime) {
          networkLogs.sort((a, b) => a.duration?.compareTo(b.duration ?? Duration.zero) ?? 0);
        } else if (sortType.isEndpoint) {
          networkLogs.sort((a, b) => a.request.path.compareTo(b.request.path));
        }
      });
    } finally {
      _isDialogOpen = false;
    }
  }

  static void onDeleteAllLogsTap() => _instance?.setState(networkLogs.clear);
}
