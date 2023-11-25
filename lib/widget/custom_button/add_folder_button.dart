import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/state_notifier_provider.dart';
import '../../settings/color/my_color.dart';

class AddFolderButton extends ConsumerWidget {
  const AddFolderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColor.colorOfControls,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(40, 40),
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        // Проверим последнюю запись в списке
        final lastEntry = ref.read(folderNotifierProvider).last;
        if (lastEntry['source'] != null && lastEntry['destination'] != null) {
          // Если поля source и destination не равны null, добавляем новую запись
          final map = <String, dynamic>{'selected': false, 'source': null, 'destination': null};
          ref.read(folderNotifierProvider.notifier).addEntry(map);
        }
      },
      child: const Icon(Icons.add, size: 25),
    );
  }
}
