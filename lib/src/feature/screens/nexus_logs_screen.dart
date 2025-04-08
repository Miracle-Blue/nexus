import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/utils/app_colors.dart';
import '../controllers/nexus_logs_controller.dart';
import '../widgets/log_button.dart';

/// Screen that shows the logs of the network requests
class NexusLogsScreen extends StatefulWidget {
  /// Constructor for the [NexusLogsScreen] class.
  const NexusLogsScreen({required this.dios, super.key});

  /// The list of [Dio] instances
  final List<Dio> dios;

  @override
  State<NexusLogsScreen> createState() => _NexusLogsScreenState();
}

class _NexusLogsScreenState extends NexusLogsController {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: CupertinoPageScaffold(
      backgroundColor: AppColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        middle: switch (NexusLogsController.searchEnabled) {
          true => TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 12, left: 12, top: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.lavaStone),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.lavaStone),
              ),
            ),
          ),
          false => null,
        },
        leading: switch (NexusLogsController.searchEnabled) {
          true => null,
          false => const Text(
            'Nexus Network Monitor',
            style: TextStyle(color: AppColors.lavaStone, fontWeight: FontWeight.w600, fontSize: 18),
          ),
        },
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
                  (context, index) => LogButton(
                    log: NexusLogsController.networkLogs[NexusLogsController.networkLogs.length - 1 - index],
                  ),
            ),
          },
        ],
      ),
    ),
  );
}
