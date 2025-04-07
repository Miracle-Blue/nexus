import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:intl/intl.dart';

import '../../common/extension/curl_extension.dart';
import '../../common/extension/duration_extension.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/app_colors.dart';
import '../../common/utils/helpers.dart';
import '../screens/nexus_log_detail_screen.dart';

class NexusLogButton extends StatelessWidget {
  const NexusLogButton({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  Widget build(BuildContext context) => CupertinoButton(
    onPressed:
        () => Navigator.push(context, CupertinoPageRoute<void>(builder: (context) => NexusLogDetailScreen(log: log))),
    onLongPress: () {
      Clipboard.setData(ClipboardData(text: log.request.toCurlString()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request copied to clipboard')));
    },
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: log.methodBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: log.methodColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (log.request.baseUrl.isNotEmpty)
              Row(
                children: [
                  /// For secure request
                  if (log.request.baseUrl.contains('https')) ...[
                    const Icon(Icons.lock_outline_rounded, size: 10, color: AppColors.red),
                    const SizedBox(width: 4),
                  ],

                  /// Request Base URL
                  Expanded(
                    child: Text(
                      log.request.baseUrl * 3,
                      style: const TextStyle(color: AppColors.grayRussian, fontSize: 10, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 4),

            /// Request Path
            Row(
              children: [
                Expanded(
                  child: Text(
                    log.request.path,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.lavaStone, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),

                /// Request Size
                if (!log.isLoading)
                  Text(
                    '${Helpers.formatBytes(log.sendBytes)} / ${Helpers.formatBytes(log.receiveBytes)}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.black),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Request Method (GET, POST, PUT, DELETE)
                Container(
                  width: 60,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: log.methodColor, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    log.request.method,
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),

                /// Request Time
                Text(
                  DateFormat('HH:mm:ss:SSS').format(log.sendTime ?? DateTime.now()),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.black),
                ),
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.white,
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.black),
                ),

                /// Request Duration
                Text(
                  log.duration.formatCompactDuration,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.black),
                ),

                switch (log.isLoading) {
                  true => SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: log.methodColor,
                      strokeCap: StrokeCap.round,
                      strokeWidth: 2,
                    ),
                  ),
                  false => Text(
                    log.response?.statusCode.toString() ?? 'null',
                    style: TextStyle(
                      color: switch (log.response?.statusCode) {
                        _ when 200 <= (log.response?.statusCode ?? 0) && (log.response?.statusCode ?? 0) < 300 =>
                          AppColors.magicalMalachite,
                        _ => AppColors.red,
                      },
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                },
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
