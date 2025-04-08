import 'package:flutter/material.dart';

import '../../common/utils/copy_log_data.dart';
import '../../common/utils/helpers.dart';
import '../screens/nexus_log_detail_screen.dart';

/// Abstract class that extends [State] and [TickerProviderStateMixin] and helps to control the [NexusLogDetailScreen]
abstract class NexusLogDetailController extends State<NexusLogDetailScreen> with TickerProviderStateMixin {
  /// The tab controller for the [NexusLogDetailScreen]
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  /// Method that handles the copy log tap
  void onCopyLogTap() =>
      Helpers.copyAndShowSnackBar(context, contentToCopy: CopyLogData(log: widget.log).toCopyableLogData);
}
