import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/models/nexus_network_log.dart';
import '../../common/utils/app_colors.dart';
import '../controllers/nexus_log_detail_controller.dart';
import '../widgets/log_overview_widget.dart';
import '../widgets/log_preview_widget.dart';
import '../widgets/log_request_widget.dart';
import '../widgets/log_response_widget.dart';

/// Screen that shows the details of a network request
class NexusLogDetailScreen extends StatefulWidget {
  /// Constructor for the [NexusLogDetailScreen] class.
  const NexusLogDetailScreen({required this.log, super.key});

  /// The network log to display
  final NexusNetworkLog log;

  @override
  State<NexusLogDetailScreen> createState() => _NexusLogDetailScreenState();
}

class _NexusLogDetailScreenState extends NexusLogDetailController {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: CupertinoPageScaffold(
      backgroundColor: AppColors.white,
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop<void>(),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 24, color: AppColors.gunmetal),
        ),
        middle: const Text('NEXUS - HTTP Request detail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        bottom: TabBar(
          controller: tabController,
          labelColor: AppColors.magicalMalachite,
          dividerHeight: 0.8,
          indicatorColor: AppColors.magicalMalachite,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline)),
            Tab(icon: Icon(Icons.arrow_upward_rounded)),
            Tab(icon: Icon(Icons.arrow_downward_rounded)),
            Tab(icon: Icon(Icons.preview_outlined)),
          ],
        ),
      ),
      child: Stack(
        children: [
          TabBarView(
            controller: tabController,
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              LogOverviewWidget(log: widget.log),
              LogRequestWidget(log: widget.log),
              LogResponseWidget(log: widget.log),
              LogPreviewWidget(log: widget.log),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 32),
              child: FloatingActionButton(
                onPressed: onCopyLogTap,
                tooltip: 'Copy full log',
                backgroundColor: AppColors.magicalMalachite,
                child: const Icon(Icons.copy_all_rounded, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
