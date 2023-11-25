import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import '../settings/color/my_color.dart';
import '../widget/custom_button/add_folder_button.dart';
import '../widget/custom_button/synchronize_button.dart';
import '../widget/draggeble_app_bar.dart';
import 'main_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith(
              (_) => const BorderSide(width: 1, color: Color(0xff525252))),
          fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return MyColor.colorOfControls;
              } else {
                return Colors.transparent;
              }
            },
          ),
          checkColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
      home: const DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          image: DecorationImage(
            image: Svg('assets/background5.svg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: DraggebleAppBar(),
          body: SizedBox.expand(
            child: MainView(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: Row(
            children: [
              AddFolderButton(),
              SizedBox(width: 20),
              SynchronizeButton(),
            ],
          ),
        ),
      ),
    );
  }
}
