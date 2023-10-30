import 'package:flutter/material.dart';
import 'package:synchronizing_directories/settings/style.dart';

abstract class MyText {
  // Запрещаем создание экземпляров
  MyText._();

  static Text textColumn(String title) {
    return Text(title, textAlign: TextAlign.center, style: MyStyle.title1Style);
  }

  static Text textCell(String? title) {
    if (title == null || title.isEmpty) {
      return const Text('Нажмите для выбора директории',
          softWrap: true, style: MyStyle.title2Style);
    } else {
      return Text(_formatText(title), softWrap: true, style: MyStyle.title2Style);
    }
  }

  static String _formatText(String path) {
    const n = 30; // желаемая максимальная длина подстроки
    final list = path.split('\\');
    // буферная строка для накопления результата
    String? buf;
    final result = <String>[];
    for (int i = 0; i < list.length; i++) {
      buf == null ? buf = list[i] : buf = '$buf\\${list[i]}';
      if (buf.length > n) {
        if (i != list.length - 1) {
          // Если это не последний элемент в списке list, добавляем в конце //
          result.add('$buf\\');
          buf = null;
        } else {
          // Если это последний элемент в списке list, добавлять в конце // не нужно
          result.add(buf);
          buf = null;
        }
      }
      if (i == list.length - 1 && buf != null) {
        // Последний элемент в списке list, добавляем в результирующий массив
        result.add(buf);
        buf = null;
      }
    }
    return result.join('\n');
  }
}
