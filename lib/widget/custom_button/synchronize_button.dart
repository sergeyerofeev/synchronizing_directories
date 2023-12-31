import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io/io.dart';
import 'package:synchronizing_directories/settings/style.dart';

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
        if (allSelectedFolder.isEmpty) {
          // Не выбрано ни одной записи
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text('Не выбрано ни одной записи!', style: MyStyle.alertDialogStyle),
            ),
          );
        } else {
          // Показываем диалоговое окно ожидания
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const AlertDialog(
              title: Text('Выполняется синхронизация...', style: MyStyle.alertDialogStyle),
              content: SizedBox(
                height: 10.0,
                child: Center(
                  child: LinearProgressIndicator(
                    color: Colors.greenAccent,
                    backgroundColor: Color(0xff707070),
                  ),
                ),
              ),
            ),
          );
          // Если копирование производилось установим флаг в true
          bool copyFlag = false;
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
                if (!checkDirectoryExistence) {
                  copyFlag = true;
                  // Создадим директорию, т. к. в папке назначения она не существует
                  await copyPath(file.path, path);
                }
              } else if (file.statSync().type == FileSystemEntityType.file) {
                File sourceFile = File(file.path);
                final name = file.path.replaceAll('${entry['source']}\\', '');
                final path = '${entry['destination']}\\$name';
                File destinationFile = File(path);
                final checkFileExistence = await destinationFile.exists();
                if (checkFileExistence) {
                  // Файл сушествует в папке назначения, проверяем у него дату модификации
                  final sourceStat = await sourceFile.stat();
                  final destinationStat = await destinationFile.stat();
                  if (sourceStat.modified.difference(destinationStat.modified).inMinutes > 0) {
                    await sourceFile.copy(path);
                  }
                } else {
                  copyFlag = true;
                  // Файл не существует, копируем
                  await sourceFile.copy(path);
                }
              }
            }
          }
          Timer(Duration(seconds: 3), () {
            // Окончание процесса синхронизации
            Navigator.of(context).pop();
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                if (copyFlag) {
                  return const AlertDialog(
                    title: Text('Синхронизация успешно завершена', style: MyStyle.alertDialogStyle),
                  );
                } else {
                  return const AlertDialog(
                    title: Text('Синхронизация не требуется', style: MyStyle.alertDialogStyle),
                  );
                }
              },
            );
          });
        }
      },
      child: const Text('Выполнить синхронизацию'),
    );
  }
}
