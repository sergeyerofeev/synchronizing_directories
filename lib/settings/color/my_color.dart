import 'package:flutter/material.dart';

abstract class MyColor {
  // Запрещаем создание экземпляров
  MyColor._();

  static const appBarColor = Color(0xffffffff);
  static const backgroundStartColor = Color(0xffffffff);
  static const backgroundEndColor = Color(0xffe8f6ff);

  static const borderColor = Color(0xFF688498);
  static const selectedColor = Color(0xa5dee6ee);

  static const colorOfControls = Color(0xff2f70af);
}
