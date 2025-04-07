import 'package:flutter/material.dart';

import '../../common/extension/duration_extension.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/helpers.dart';
import 'list_row_item.dart';

class LogOverviewWidget extends StatelessWidget {
  const LogOverviewWidget({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      ListRowItem(name: 'Method', value: log.request.method),
      ListRowItem(name: 'URL', value: log.request.baseUrl, showCopyButton: true),
      ListRowItem(name: 'Endpoint', value: log.request.path, showCopyButton: true),
      ListRowItem(name: 'Status', value: log.response?.statusCode.toString() ?? 'null'),
      ListRowItem(name: 'Time', value: log.duration?.formatCompactDuration ?? 'null'),
      ListRowItem(name: 'Bytes Sent', value: Helpers.formatBytes(log.sendBytes)),
      ListRowItem(name: 'Bytes Received', value: Helpers.formatBytes(log.receiveBytes), showDivider: false),
    ],
  );
}
