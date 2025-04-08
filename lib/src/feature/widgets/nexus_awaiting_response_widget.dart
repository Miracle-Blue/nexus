import 'package:flutter/material.dart';

import '../../common/utils/app_colors.dart';

class NexusAwaitingResponseWidget extends StatelessWidget {
  const NexusAwaitingResponseWidget({super.key, this.message = 'Awaiting response...'});

  final String message;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            backgroundColor: AppColors.white,
            color: AppColors.magicalMalachite,
            strokeCap: StrokeCap.round,
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: AppColors.gunmetal, fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );
}
