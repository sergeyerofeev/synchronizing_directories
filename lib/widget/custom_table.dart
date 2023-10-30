import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:synchronizing_directories/core/key_store.dart';
import 'package:synchronizing_directories/provider/provider.dart';
import 'package:synchronizing_directories/provider/state_notifier_provider.dart';
import 'package:synchronizing_directories/settings/color/my_color.dart';
import 'package:synchronizing_directories/settings/text.dart';

class CustomTable extends ConsumerWidget {
  const CustomTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderList = ref.watch(folderNotifierProvider);

    return DataTable(
      columns: _createColumns(),
      rows: _createRows(ref, folderList),
      dataRowMaxHeight: double.infinity,
      columnSpacing: 30.0,
      horizontalMargin: 15.0,
      checkboxHorizontalMargin: 15.0,
      dataRowColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        const Set<MaterialState> interactiveStates = <MaterialState>{MaterialState.selected};
        if (states.any(interactiveStates.contains)) {
          return MyColor.selectedColor;
        }
        return null;
      }),
      border: const TableBorder(
        top: BorderSide(color: MyColor.borderColor, width: 1),
        bottom: BorderSide(color: MyColor.borderColor, width: 1),
        horizontalInside: BorderSide(color: MyColor.borderColor, width: 1),
        verticalInside: BorderSide(color: MyColor.borderColor, width: 1),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: Expanded(
          child: MyText.textColumn('Откуда копировать'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: MyText.textColumn('Куда копировать'),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: MyText.textColumn('Удалить\nзапись'),
        ),
      ),
    ];
  }

  List<DataRow> _createRows(WidgetRef ref, List<Map<String, dynamic>> folderList) {
    return folderList
        .mapIndexed(
          (index, folder) => DataRow(
            cells: [
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: MyText.textCell(folder['source']),
                  ),
                ),
                onTap: () async {
                  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

                  if (selectedDirectory != null) {
                    folder['source'] = selectedDirectory;
                    ref.read(folderNotifierProvider.notifier).changeEntry(folder, index);
                    // Сохраняем список в хранилище
                    await ref
                        .read(storageProvider)
                        .set(KeyStore.dataTable, ref.read(folderNotifierProvider));
                  }
                },
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyText.textCell(folder['destination']),
                ),
                onTap: () async {
                  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

                  if (selectedDirectory != null) {
                    folder['destination'] = selectedDirectory;
                    ref.read(folderNotifierProvider.notifier).changeEntry(folder, index);
                    // Сохраняем список в хранилище
                    await ref
                        .read(storageProvider)
                        .set(KeyStore.dataTable, ref.read(folderNotifierProvider));
                  }
                },
              ),
              DataCell(
                const Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.delete),
                ),
                onTap: () async {
                  ref.read(folderNotifierProvider.notifier).removeEntry(folder);
                  // Сохраняем список в хранилище
                  await ref
                      .read(storageProvider)
                      .set(KeyStore.dataTable, ref.read(folderNotifierProvider));
                },
              ),
            ],
            selected: folder['selected'],
            onSelectChanged: (bool? selected) async {
              if (folder['source'] != null && folder['destination'] != null) {
                folder['selected'] = selected!;
                ref.read(folderNotifierProvider.notifier).changeEntry(folder, index);
                // Сохраняем список в хранилище
                await ref
                    .read(storageProvider)
                    .set(KeyStore.dataTable, ref.read(folderNotifierProvider));
              }
            },
          ),
        )
        .toList();
  }
}
