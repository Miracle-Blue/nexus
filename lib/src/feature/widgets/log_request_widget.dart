import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/extension/object_extension.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/helpers.dart';
import 'list_row_item.dart';

class LogRequestWidget extends StatelessWidget {
  const LogRequestWidget({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      ListRowItem(
        name: 'Started',
        value: DateFormat('dd-MM-yyyy │ HH:mm:ss:SSS').format(log.sendTime ?? DateTime.now()),
      ),
      ListRowItem(name: 'Bytes sent', value: Helpers.formatBytes(log.sendBytes)),
      ListRowItem(name: 'Headers', value: log.request.headers.prettyJson, showCopyButton: true, isJson: true),
      ListRowItem(name: 'Body', value: (log.request.data as Object?).prettyJson, showCopyButton: true, isJson: true),
      ListRowItem(
        name: 'Query Parameters',
        value: (log.request.queryParameters as Object?).prettyJson,
        showCopyButton: true,
        showDivider: false,
        isJson: true,
      ),
    ],
  );
}
