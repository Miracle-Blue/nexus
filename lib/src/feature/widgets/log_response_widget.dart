import 'package:flutter/material.dart';

import '../../common/extension/object_extension.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/helpers.dart';
import 'list_row_item.dart';

class LogResponseWidget extends StatefulWidget {
  const LogResponseWidget({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  State<LogResponseWidget> createState() => _LogResponseWidgetState();
}

class _LogResponseWidgetState extends State<LogResponseWidget> {
  late final List<Widget> _items;

  @override
  void initState() {
    super.initState();
    _items = <Widget>[
      ListRowItem(name: 'Received', value: Helpers.formatBytes(widget.log.receiveBytes)),
      ListRowItem(name: 'Bytes received', value: Helpers.formatBytes(widget.log.receiveBytes)),
      ListRowItem(name: 'Status', value: widget.log.response?.statusCode.toString()),
      if (widget.log.response?.data != null)
        ListRowItem(
          name: 'Body',
          value: (widget.log.response?.data).prettyJson,
          showCopyButton: true,
          showDivider: false,
        ),
    ];
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ListView.builder(itemCount: _items.length, itemBuilder: (context, index) => _items[index]);
}
