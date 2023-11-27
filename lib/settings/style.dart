import 'package:flutter/material.dart';

abstract class MyStyle {
  // Запрещаем создание экземпляров
  MyStyle._();

  static const TextStyle title1Style = TextStyle(
    fontSize: 16,
    color: Colors.brown,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title2Style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle alertDialogStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );
}
