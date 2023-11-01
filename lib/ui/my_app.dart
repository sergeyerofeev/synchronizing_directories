import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:synchronizing_directories/ui/main_view.dart';

import '../core/key_store.dart';
import '../provider/provider.dart';
import '../settings/color/my_color.dart';
import '../widget/custom_button.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith(
              (_) => const BorderSide(width: 1, color: Colors.grey)),
          fillColor: MaterialStateProperty.all(MyColor.colorOfControls),
          checkColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          titleSpacing: 0,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: WindowTitleBarBox(
            child: Container(
              color: MyColor.appBarColor,
              child: Row(
                children: [Expanded(child: MoveWindow()), const WindowButtons()],
              ),
            ),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MyColor.backgroundStartColor, MyColor.backgroundEndColor],
                  stops: [0.0, 1.0],
                ),
              ),
              child: const MainView()),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: const Row(
          children: [
            AddFolderButton(),
            SizedBox(width: 20),
            SynchronizeButton(),
          ],
        ),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
  iconNormal: const Color(0xFF805306),
  mouseOver: const Color(0xffc4c4c4),
  mouseDown: const Color(0xFF805306),
  iconMouseOver: const Color(0xFF805306),
  iconMouseDown: const Color(0xFFE1B19F),
);

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xffe32020),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: const Color(0xFF805306),
  iconMouseOver: Colors.white,
);

class WindowButtons extends ConsumerWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: closeButtonColors,
          onPressed: () {
            // Сохраняем ширину и высоту окна для использования при перезапуске программы
            final size = MediaQuery.of(context).size;
            ref.read(storageProvider).set<double>(KeyStore.windowWidth, size.width);
            ref.read(storageProvider).set<double>(KeyStore.windowHeight, size.height - 1.0);

            // Получим и сохраним положение окна на экране монитора
            final position = appWindow.position;
            ref.read(storageProvider).set<double>(KeyStore.offsetX, position.dx);
            ref.read(storageProvider).set<double>(KeyStore.offsetY, position.dy);

            appWindow.close();
          },
        ),
      ],
    );
  }
}
