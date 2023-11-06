import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'core/key_store.dart';
import 'data/data_sources/storage.dart';
import 'provider/provider.dart';
import 'provider/state_notifier_provider.dart';
import 'ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

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

  WindowOptions windowOptions = WindowOptions(
    size: Size(windowWidth ?? 780, windowHeight ?? 450),
    minimumSize: const Size(780, 450),
    skipTaskbar: false,
    title: 'Синхронизация директорий',
    titleBarStyle: TitleBarStyle.hidden, // Скрыть панель с кнопками Windows
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Начальное положение окна
    if (dx == null || dy == null) {
      // Если пользователь не выбрал положение окна на экране монитора, размещаем по центру
      await windowManager.center();
    } else {
      await windowManager.setPosition(Offset(dx, dy));
    }
    // await windowManager.setAlwaysOnTop(true); // Размещаем приложение поверх других окон
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ProviderScope(
    overrides: [
      // Устанавливаем новые объекты
      storageProvider.overrideWithValue(Storage(sharedPreferences)),
      folderNotifierProvider.overrideWith((ref) => FolderNotifier(dataTable)),
    ],
    child: const MyApp(),
  ));
}
