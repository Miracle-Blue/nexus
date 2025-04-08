import 'package:flutter/material.dart';

import '../../common/extension/object_extension.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/helpers.dart';
import 'html_renderer.dart';
import 'list_row_item.dart';
import 'nexus_awaiting_response_widget.dart';

class LogResponseWidget extends StatefulWidget {
  const LogResponseWidget({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  State<LogResponseWidget> createState() => _LogResponseWidgetState();
}

class _LogResponseWidgetState extends State<LogResponseWidget> {
  late final List<Widget> _items;

  String get _contentType => widget.log.response?.headers['content-type']?.first ?? '';

  @override
  void initState() {
    super.initState();
    _items = <Widget>[
      ListRowItem(name: 'Received', value: Helpers.formatBytes(widget.log.receiveBytes)),
      ListRowItem(name: 'Bytes received', value: Helpers.formatBytes(widget.log.receiveBytes)),
      ListRowItem(name: 'Status', value: widget.log.response?.statusCode.toString()),
      ListRowItem(name: 'Content-Type', value: _contentType),
      if (widget.log.response?.data != null && !_contentType.contains('html'))
        ListRowItem(
          name: 'Body',
          value: (widget.log.response?.data).prettyJson,
          showCopyButton: true,
          showDivider: false,
          isJson: true,
        ),
      if (_contentType.contains('html')) ...[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('HTML Response', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          child: HtmlRenderer(htmlContent: widget.log.response?.data.toString() ?? ''),
        ),
      ],
    ];
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scrollbar(
    controller: PrimaryScrollController.of(context),
    child: switch (widget.log.isLoading) {
      true => const NexusAwaitingResponseWidget(),
      false => ListView.builder(itemCount: _items.length, itemBuilder: (context, index) => _items[index]),
    },
  );
}
