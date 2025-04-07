import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/utils/share_log_data.dart';
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

  void onShareTap() {
    Share.share(ShareLogData(log: widget.log).toShareableLogData);
  }
}
