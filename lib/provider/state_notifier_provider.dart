import 'package:flutter_riverpod/flutter_riverpod.dart';

final folderNotifierProvider =
    StateNotifierProvider.autoDispose<FolderNotifier, List<Map<String, dynamic>>>(
        (ref) => throw UnimplementedError());

class FolderNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  // Инициализируем список одной записью
  FolderNotifier(List<Map<String, dynamic>>? list)
      : super(list != null && list.isNotEmpty
            ? list
            : [
                {
                  'selected': false,
                  'source': null,
                  'destination': null,
                },
              ]);

  // Добавление записи
  void addEntry(Map<String, dynamic> map) {
    state = [...state, map];
  }

  // Удаление записи
  void removeEntry(Map<String, dynamic> map) {
    state = [
      for (final entry in state)
        if (entry != map) entry
    ];
  }

  // В записи произошли изменения, произодим замену в списке
  void changeEntry(Map<String, dynamic> map, int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          // индексы совпали, меняем запись на новую
          map
        else
          // Другие записи без изменения
          state[i]
    ];
  }
}
