import 'package:flutter/material.dart';

import '../../common/utils/app_colors.dart';
import '../../common/utils/helpers.dart';

class ListRowItem extends StatelessWidget {
  const ListRowItem({
    required this.value,
    this.name,
    this.showCopyButton = false,
    this.showDivider = true,
    this.isJson = false,
    super.key,
  });

  final String? name;
  final String? value;
  final bool showCopyButton;
  final bool showDivider;
  final bool isJson;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: showCopyButton ? 0 : 8, horizontal: 6),
        child: Row(
          crossAxisAlignment: isJson ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// If the value is JSON, display it in a column.
            switch (isJson) {
              true => Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (name != null && (name?.isNotEmpty ?? false)) ...[
                      SelectableText('$name:', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                    ],
                    SelectableText(
                      value ?? 'null',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.gunmetal, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              false => Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (name != null && (name?.isNotEmpty ?? false)) ...[
                      SelectableText('$name:', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: SelectableText(
                        value ?? 'null',
                        style: const TextStyle(fontSize: 12.5, color: AppColors.gunmetal, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            },
            if (showCopyButton)
              IconButton(
                onPressed: () => Helpers.copyAndShowSnackBar(context, contentToCopy: value ?? 'null'),
                icon: const Icon(Icons.copy, size: 18),
              ),
          ],
        ),
      ),
      if (showDivider) const Divider(height: 5),
    ],
  );
}
