import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/utils/app_colors.dart';
import '../controllers/nexus_logs_controller.dart';
import '../widgets/nexus_log_button.dart';

class NexusLogsScreen extends StatefulWidget {
  const NexusLogsScreen({required this.dios, super.key});

  final List<Dio> dios;

  @override
  State<NexusLogsScreen> createState() => _NexusLogsScreenState();
}

class _NexusLogsScreenState extends NexusLogsController {
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    backgroundColor: AppColors.white,
    navigationBar: CupertinoNavigationBar(
      backgroundColor: Colors.white.withValues(alpha: 0.1),
      leading: const Text(
        'Nexus Network Monitor',
        style: TextStyle(color: AppColors.lavaStone, fontWeight: FontWeight.w600, fontSize: 18),
      ),
    ),
    child: Stack(
      children: [
        switch (NexusLogsController.networkLogs.isEmpty) {
          true => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off, size: 48, color: AppColors.grayRussian),
                Text('No logs here yet', style: TextStyle(color: AppColors.grayRussian, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          false => ListView.builder(
            itemCount: NexusLogsController.networkLogs.length,
            itemBuilder:
                (context, index) => NexusLogButton(
                  log: NexusLogsController.networkLogs[NexusLogsController.networkLogs.length - 1 - index],
                ),
          ),
        },
      ],
    ),
  );
}
