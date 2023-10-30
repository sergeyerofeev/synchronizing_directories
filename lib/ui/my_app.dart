import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:synchronizing_directories/ui/main_view.dart';

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

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
