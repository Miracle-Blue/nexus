import 'package:flutter/material.dart';

import '../../common/utils/app_colors.dart';

class NexusAwaitingResponseWidget extends StatelessWidget {
  const NexusAwaitingResponseWidget({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: AppColors.white,
          color: AppColors.magicalMalachite,
          strokeCap: StrokeCap.round,
        ),
        SizedBox(height: 8),
        Text('Awaiting response...', style: TextStyle(color: AppColors.gunmetal, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
