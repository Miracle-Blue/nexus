import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/utils/app_colors.dart';

class ListRowItem extends StatelessWidget {
  const ListRowItem({required this.name, required this.value, super.key});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SelectableText('$name:', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Flexible(
                  child: SelectableText(value, style: const TextStyle(fontSize: 13, color: AppColors.lavaStone)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
            },
            icon: const Icon(Icons.copy, size: 18),
          ),
        ],
      ),
      const Divider(height: 1),
    ],
  );
}
