import 'package:flutter/material.dart';

import '../../common/extension/duration_extension.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/helpers.dart';
import 'list_row_item.dart';

class LogOverviewWidget extends StatelessWidget {
  const LogOverviewWidget({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListRowItem(name: 'Method', value: log.request.method),
      ListRowItem(name: 'URL', value: log.request.baseUrl),
      ListRowItem(name: 'Status', value: log.response?.statusCode.toString() ?? 'null'),
      ListRowItem(name: 'Time', value: log.duration?.formatCompactDuration ?? 'null'),
      ListRowItem(name: 'Bytes sent', value: Helpers.formatBytes(log.sendBytes)),
      ListRowItem(name: 'Bytes received', value: Helpers.formatBytes(log.receiveBytes)),
    ],
  );
}
