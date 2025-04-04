import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/extension/duration_extension.dart';
import '../../common/models/nexus_network_log.dart';
import '../../common/utils/app_colors.dart';

class NexusLogButton extends StatelessWidget {
  const NexusLogButton({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        onPressed: log.isLoading ? null : () {},
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
              children: [
                Row(
                  children: [
                    /// Request Method (GET, POST, PUT, DELETE)
                    Container(
                      width: 70,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: log.methodColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        log.request.method,
                        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 12),

                    /// Request URL
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (log.request.baseUrl.isNotEmpty)
                            Row(
                              children: [
                                /// For secure request
                                if (log.request.baseUrl.contains('https')) ...[
                                  const Icon(Icons.lock_outline_rounded, size: 10, color: AppColors.red),
                                  const SizedBox(width: 4)
                                ],

                                /// Request Base URL
                                Expanded(
                                  child: Text(
                                    log.request.baseUrl * 3,
                                    style: const TextStyle(
                                      color: AppColors.grayRussian,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                          /// Request Path
                          Text(
                            log.request.path,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.lavaStone,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Request Time
                    Text(
                      DateFormat('HH:mm:ss:SSS').format(log.timestamp),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),

                    /// Request Duration
                    Text(
                      log.duration.formatCompactDuration,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
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
                    }
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
