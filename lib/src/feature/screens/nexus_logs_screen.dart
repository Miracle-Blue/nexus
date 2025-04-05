import 'package:dio/dio.dart';
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
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: AppColors.magicalMalachite,
      centerTitle: false,
      title: const Text(
        'Nexus Network Monitor',
        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      shadowColor: const Color.fromARGB(255, 201, 202, 206),
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 8,
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.sort_rounded, color: Colors.white, size: 20),
              tooltip: 'Sort',
              onPressed: () => onOperationTypeSelected(OperationType.sort),
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded, color: Colors.white, size: 20),
              tooltip: 'Delete',
              onPressed: () => onOperationTypeSelected(OperationType.delete),
            ),
          ],
        ),
      ],
    ),
    body: SafeArea(
      child: switch (networkLogs.isEmpty) {
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
          itemCount: networkLogs.length,
          itemBuilder: (context, index) => NexusLogButton(log: networkLogs[networkLogs.length - 1 - index]),
        ),
      },
    ),
  );
}
