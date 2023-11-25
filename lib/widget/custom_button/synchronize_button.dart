import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io/io.dart';

import '../../provider/state_notifier_provider.dart';
import '../../settings/color/my_color.dart';

class SynchronizeButton extends ConsumerWidget {
  const SynchronizeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColor.colorOfControls,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(220, 40),
      ),
      onPressed: () async {
        // Получим из таблицы все отмеченные записи
        final allSelectedFolder =
            ref.read(folderNotifierProvider).where((element) => element['selected'] == true).toList();
        // Обрабатываем каждую выбранную запись из allSelectedForlder
        for (Map<String, dynamic> entry in allSelectedFolder) {
          // Получаем все папки и файлы в переданной директории
          List<FileSystemEntity> allContents =
              await Directory(entry['source']).list(recursive: true).toList();
          for (FileSystemEntity file in allContents) {
            if (file.statSync().type == FileSystemEntityType.directory) {
              // Вырежем из источника главную директорию оставив только пути дочерних директорий
              final name = file.path.replaceAll('${entry['source']}\\', '');
              // Добавим полученный путь к директории назначения
              final path = '${entry['destination']}\\$name';
              final checkDirectoryExistence = await Directory(path).exists();
              if (checkDirectoryExistence) {
                print('Directory: $name is exists');
              } else {
                print('Directory: $name is not exists');
                await copyPath(file.path, path);
              }
            } else if (file.statSync().type == FileSystemEntityType.file) {
              File sourceFile = File(file.path);
              final name = file.path.replaceAll('${entry['source']}\\', '');
              final path = '${entry['destination']}\\$name';
              File destinationFile = File(path);
              final checkFileExistence = await destinationFile.exists();
              if (checkFileExistence) {
                print('Directory: $name is exists');
                final sourceStat = await sourceFile.stat();
                final destinationStat = await destinationFile.stat();
                if (sourceStat.modified.difference(destinationStat.modified).inMinutes > 0) {
                  await sourceFile.copy(path);
                }
              } else {
                print('Directory: $name is not exists');
                await sourceFile.copy(path);
              }
            }
          }
        }
      },
      child: const Text('Выполнить синхронизацию'),
    );
  }
}