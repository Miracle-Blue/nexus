import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/utils/copy_log_data.dart';
import '../screens/nexus_log_detail_screen.dart';

abstract class NexusLogDetailController extends State<NexusLogDetailScreen> with TickerProviderStateMixin {
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

  void onCopyLogTap() => Clipboard.setData(ClipboardData(text: CopyLogData(log: widget.log).toCopyableLogData));
}
