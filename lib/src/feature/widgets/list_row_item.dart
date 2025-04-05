import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/utils/app_colors.dart';

class ListRowItem extends StatelessWidget {
  const ListRowItem({
    required this.name,
    required this.value,
    this.showCopyButton = false,
    this.showDivider = true,
    super.key,
  });

  final String name;
  final String? value;
  final bool showCopyButton;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: showCopyButton ? 0 : 12, horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText('$name:', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: SelectableText(
                      value ?? 'null',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.lavaStone),
                    ),
                  ),
                ],
              ),
            ),
            if (showCopyButton)
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value ?? 'null'));

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                },
                icon: const Icon(Icons.copy, size: 18),
              ),
          ],
        ),
      ),
      if (showDivider) const Divider(height: 5),
    ],
  );
}
