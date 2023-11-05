import 'package:flutter/material.dart';

abstract class MyColor {
  // Запрещаем создание экземпляров
  MyColor._();

  static const appBarColor = Color(0xc3f5f5f5);

  static const borderColor = Color(0xFF688498);
  static const selectedColor = Color(0xa5d5d5d5);

  static const colorOfControls = Color(0xff2f70af);
}
