import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronizing_directories/core/key_store.dart';
import 'package:synchronizing_directories/provider/provider.dart';
import 'package:synchronizing_directories/provider/state_notifier_provider.dart';

import 'data/data_sources/storage.dart';
import 'ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  // Извлекаем из хранилища положение окна на экране монитора
  final double? dx = sharedPreferences.getDouble(KeyStore.offsetX);
  final double? dy = sharedPreferences.getDouble(KeyStore.offsetY);
  // Извлекаем из хранилища ширину и высоту окна
  final double? windowWidth = sharedPreferences.getDouble(KeyStore.windowWidth);
  final double? windowHeight = sharedPreferences.getDouble(KeyStore.windowHeight);
  // Извлекаем из хранилища предыдущий набор папок
  final rawData = sharedPreferences.getStringList(KeyStore.dataTable);
  List<Map<String, dynamic>>? dataTable;
  if (rawData != null && rawData.isNotEmpty) {
    dataTable = rawData.map((entry) => jsonDecode(entry)).cast<Map<String, dynamic>>().toList();
  }
  runApp(ProviderScope(
    overrides: [
      // Устанавливаем новые объекты
      storageProvider.overrideWithValue(Storage(sharedPreferences)),
      folderNotifierProvider.overrideWith((ref) => FolderNotifier(dataTable)),
    ],
    child: const MyApp(),
  ));

  doWhenWindowReady(() {
    final win = appWindow;

    win.minSize = const Size(780, 450);
    win.size = Size(windowWidth ?? 780, windowHeight ?? 450);

    // Выполняем строго после установки размеров окна
    if (dx == null || dy == null) {
      // Если пользователь не выбрал положение окна на экране монитора, размещаем по центру
      win.alignment = Alignment.center;
    } else {
      win.position = Offset(dx, dy);
    }

    win.title = "Приложение для синхронизации директорий";
    win.show();
  });
}
