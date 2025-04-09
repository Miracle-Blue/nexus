import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/models/nexus_network_log.dart';
import '../../common/utils/nexus_interceptor.dart';
import '../overlays/sort_by_alert_dialog.dart';
import '../screens/nexus_logs_screen.dart';

/// Abstract class for the NexusLogsScreen controller that manages the network logs.
abstract class NexusLogsController extends State<NexusLogsScreen> {
  /// The singleton instance of the controller.
  static NexusLogsController? _instance;

  /// The list of network logs.
  static List<NexusNetworkLog> networkLogs = <NexusNetworkLog>[];

  /// The height of the app bar.
  final appBarHeight = 100.0;

  /// The map of interceptors for the Dio instances.
  final Map<Dio, NexusInterceptor> _interceptors = <Dio, NexusInterceptor>{};

  /// Whether the search is enabled.
  static bool searchEnabled = false;

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

  // static final List<NexusNetworkLog> networkLogs = <NexusNetworkLog>[];
  List<NexusNetworkLog>? _tempNetworkLogs;

  /// Method to search logs by their endpoint or base url
  void onSearchChanged(String query) => setState(() {
    if (query.isEmpty) {
      if (_tempNetworkLogs != null) {
        networkLogs = List<NexusNetworkLog>.from(_tempNetworkLogs!);
        _tempNetworkLogs = null;
      }
    } else {
      _tempNetworkLogs ??= List<NexusNetworkLog>.from(networkLogs);

      networkLogs =
          _tempNetworkLogs
              ?.where((log) => log.request.path.contains(query) || log.request.baseUrl.contains(query))
              .toList() ??
          [];
    }
  });

  /// The current sort type for the network logs.
  static SortType sortType = SortType.createTime;

  /// Whether the sort by alert dialog is currently open.
  static bool _isDialogOpen = false;

  /// Show the sort by alert dialog and update the sort type.
  static Future<void> onSortLogsTap() async {
    final context = _instance?.context;
    if (context == null) return;

    // Check if dialog is already open, if so, return early
    if (_isDialogOpen) {
      return Navigator.of(context, rootNavigator: true).pop<void>();
    }

    _isDialogOpen = true;

    try {
      final result = await showSortByAlertDialog(context, sortType: sortType);

      if (result != null) sortType = result;

      _instance?.setState(
        () => switch (result) {
          SortType.createTime => networkLogs.sort((a, b) => a.sendTime?.compareTo(b.sendTime ?? DateTime.now()) ?? 0),
          SortType.responseTime => networkLogs.sort((a, b) => a.duration?.compareTo(b.duration ?? Duration.zero) ?? 0),
          SortType.endpoint => networkLogs.sort((a, b) => a.request.path.compareTo(b.request.path)),
          SortType.responseSize => networkLogs.sort((a, b) => a.receiveBytes?.compareTo(b.receiveBytes ?? 0) ?? 0),
          _ => null,
        },
      );
    } finally {
      _isDialogOpen = false;
    }
  }

  /// Method to delete all network logs.
  static void onDeleteAllLogsTap() {
    if (_isDialogOpen && _instance != null) Navigator.of(_instance!.context).pop<void>();

    _instance?.setState(networkLogs.clear);
  }

  /// Static method to toggle the search.
  static void toggleSearch() {
    if (_isDialogOpen && _instance != null) Navigator.of(_instance!.context).pop<void>();

    _instance?.setState(() => searchEnabled = !searchEnabled);
  }
}
