import 'package:flutter/material.dart';

import '../../common/extension/object_extension.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/helpers.dart';
import 'html_renderer.dart';
import 'list_row_item.dart';
import 'nexus_awaiting_response_widget.dart';

/// A widget that displays the response of a network request.
class LogResponseWidget extends StatefulWidget {
  const LogResponseWidget({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  State<LogResponseWidget> createState() => _LogResponseWidgetState();
}

class _LogResponseWidgetState extends State<LogResponseWidget> {
  bool _showJsonResponse = true;
  late Future<String> _jsonResponse;
  String get _contentType => widget.log.response?.headers['content-type']?.first ?? '';

  @override
  void initState() {
    super.initState();
    _jsonResponse = _loadJson();
    _showJsonResponse = !_isLargeResponseBody;
  }

  /// Checks if the response body is considered large.
  bool get _isLargeResponseBody {
    final data = widget.log.response?.data;

    return data != null && data.toString().length > 100000;
  }

  /// Loads the json response asynchronously.
  Future<String> _loadJson() async {
    try {
      return await (widget.log.response?.data).prettyJsonAsync;
    } on Object catch (e) {
      return 'Error formatting JSON: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) => switch (widget.log.isLoading) {
    true => const NexusAwaitingResponseWidget(),
    false => Scrollbar(
      controller: PrimaryScrollController.of(context),
      child: ListView(
        children: [
          ListRowItem(name: 'Received', value: Helpers.formatBytes(widget.log.receiveBytes)),
          ListRowItem(name: 'Bytes received', value: Helpers.formatBytes(widget.log.receiveBytes)),
          ListRowItem(name: 'Status', value: widget.log.response?.statusCode.toString()),
          ListRowItem(name: 'Content-Type', value: _contentType),

          /// Checking whether data is not null, not html and json response is enabled.
          if (widget.log.response?.data != null && !_contentType.contains('html') && _showJsonResponse)
            FutureBuilder<String>(
              future: _jsonResponse,
              builder:
                  (context, snapshot) => switch (snapshot.connectionState) {
                    ConnectionState.done => ListRowItem(
                      name: 'Body',
                      value: snapshot.data,
                      showCopyButton: true,
                      showDivider: false,
                      isJson: true,
                    ),
                    _ => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const NexusAwaitingResponseWidget(message: 'Rendering JSON...'),
                    ),
                  },
            ),

          /// Checking whether json response is not enabled.
          if (!_showJsonResponse)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    'The response body is too large to display automatically. Showing it may take a long time or could potentially crash the app.',
                    style: TextStyle(fontSize: 13, color: AppColors.gunmetal, fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(AppColors.magicalMalachite),
                      foregroundColor: WidgetStatePropertyAll<Color>(AppColors.white),
                    ),
                    onPressed: () => setState(() => _showJsonResponse = true),
                    child: const Text('Show large body'),
                  ),
                ],
              ),
            ),

          /// Checking whether content type is html.
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
        ],
      ),
    ),
  };
}
