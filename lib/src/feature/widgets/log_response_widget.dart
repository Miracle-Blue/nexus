import 'dart:convert';

import 'package:flutter/material.dart';

import '../../common/models/nexus_network_log.dart';
import '../../common/utils/helpers.dart';
import 'list_row_item.dart';

class LogResponseWidget extends StatelessWidget {
  const LogResponseWidget({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      ListRowItem(name: 'Bytes received', value: Helpers.formatBytes(log.receiveBytes)),
      if (log.response?.data != null)
        ListRowItem(name: 'Body', value: jsonEncode(log.response?.data), showCopyButton: true, showDivider: false),

      // JsonView(json: log.response?.data ?? {}),
      // JsonConfig(
      //   /// your customize configuration
      //   data: JsonConfigData(

      //     animation: true,
      //     animationDuration: const Duration(milliseconds: 300),
      //     animationCurve: Curves.ease,
      //     itemPadding: const EdgeInsets.only(left: 8),
      //     color: const JsonColorScheme(stringColor: Colors.grey),
      //     style: const JsonStyleScheme(arrow: Icon(Icons.arrow_right)),
      //   ),

      //   /// any widget will contain jsonView
      // ),
    ],
  );
}
