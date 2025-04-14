import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../common/models/thunder_network_log.dart';
import '../../common/utils/thunder_interceptor.dart';
import '../overlays/sort_by_alert_dialog.dart';
import '../screens/thunder_log_detail_screen.dart';
import '../screens/thunder_logs_screen.dart';

/// Abstract class for the ThunderLogsController controller that manages the network logs.
abstract class ThunderLogsController extends State<ThunderLogsScreen> {
  /// The singleton instance of the controller.
  static ThunderLogsController? _instance;

  /// The list of network logs.
  static List<ThunderNetworkLog> networkLogs = <ThunderNetworkLog>[];

  /// The height of the app bar.
  final appBarHeight = 100.0;

  /// The map of interceptors for the Dio instances.
  final Map<Dio, ThunderInterceptor> _interceptors = <Dio, ThunderInterceptor>{};

  /// Whether the search is enabled.
  static bool searchEnabled = false;

  /// Whether the log detail screen is currently open.
  static bool inLogDetailScreen = false;

  @override
  void initState() {
    super.initState();
    _instance = this;
    _setupInterceptors();
  }

  @override
  void didUpdateWidget(covariant ThunderLogsScreen oldWidget) {
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

  /// Provides access to the current instance's [ThunderInterceptor].
  /// Throws an assertion error if the controller instance has not been initialized.
  static ThunderInterceptor get getInterceptor {
    assert(_instance != null, 'Instance not implemented');
    return _instance!._getThunderInterceptor;
  }

  /// Getter for creating a new instance of [ThunderInterceptor].
  /// This interceptor is configured with the [_onNetworkActivity] callback,
  /// which handles updates to the network log list when a network event occurs.
  ThunderInterceptor get _getThunderInterceptor => ThunderInterceptor(onNetworkActivity: _onNetworkActivity);

  void _setupInterceptors() {
    for (final interceptor in _interceptors.values) {
      for (final dio in widget.dios) {
        dio.interceptors.remove(interceptor);
      }
    }
    _interceptors.clear();

    // Add new interceptors
    for (final dio in widget.dios) {
      final interceptor = _getThunderInterceptor;
      dio.interceptors.add(interceptor);
      _interceptors[dio] = interceptor;
    }
  }

  void _onNetworkActivity(ThunderNetworkLog log) => setState(() {
    final index = networkLogs.indexWhere((existingLog) => existingLog.id == log.id);

    if (index >= 0) {
      networkLogs[index] = log;
    } else {
      networkLogs.add(log);
    }
  });

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }

  // static final List<ThunderNetworkLog> networkLogs = <ThunderNetworkLog>[];
  List<ThunderNetworkLog>? _tempNetworkLogs;

  /// Method to search logs by their endpoint or base url
  void onSearchChanged(String query) => setState(() {
    if (query.isEmpty) {
      if (_tempNetworkLogs != null) {
        networkLogs = List<ThunderNetworkLog>.from(_tempNetworkLogs!);
        _tempNetworkLogs = null;
      }
    } else {
      _tempNetworkLogs ??= List<ThunderNetworkLog>.from(networkLogs);

      networkLogs =
          _tempNetworkLogs
              ?.where(
                (log) =>
                    log.request.path.toLowerCase().contains(query.toLowerCase()) ||
                    log.request.baseUrl.toLowerCase().contains(query.toLowerCase()),
              )
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
    if (ThunderLogsController.inLogDetailScreen) {
      return;
    }

    final context = _instance?.context;
    if (context == null) {
      return;
    }

    // Check if dialog is already open, if so, return early
    if (_isDialogOpen) {
      return Navigator.of(context, rootNavigator: true).pop<void>();
    }

    _isDialogOpen = true;

    try {
      final result = await showSortByAlertDialog(context, sortType: sortType);

      if (result != null) {
        sortType = result;
      }

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
    if (ThunderLogsController.inLogDetailScreen) {
      return;
    }

    if (_isDialogOpen && _instance != null) {
      Navigator.of(_instance!.context).pop<void>();
    }

    _instance?.setState(networkLogs.clear);
  }

  /// Static method to toggle the search.
  static void toggleSearch() {
    if (ThunderLogsController.inLogDetailScreen) {
      return;
    }

    if (_isDialogOpen && _instance != null) {
      Navigator.of(_instance!.context).pop<void>();
    }

    _instance?.setState(() => searchEnabled = !searchEnabled);
  }

  /// Method to navigate to the log detail screen.
  Future<void> onLogTap(ThunderNetworkLog log) async {
    ThunderLogsController.inLogDetailScreen = true;

    await Navigator.push<void>(
      context,
      CupertinoPageRoute<void>(builder: (context) => ThunderLogDetailScreen(log: log)),
    );

    ThunderLogsController.inLogDetailScreen = false;
  }
}
