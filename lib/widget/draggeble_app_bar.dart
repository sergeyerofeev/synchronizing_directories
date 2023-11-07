import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../core/key_store.dart';
import '../provider/provider.dart';
import '../settings/color/my_color.dart';

class DraggebleAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DraggebleAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: MyColor.appBarColor,
        border: Border(
          top: BorderSide(
            color: Color(0xff707070),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          getAppBarTitle(),
          SizedBox(
            height: kWindowCaptionHeight,
            child: DragToResizeArea(
              enableResizeEdges: const [
                ResizeEdge.topLeft,
                ResizeEdge.top,
                ResizeEdge.topRight,
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  WindowCaptionButton.minimize(
                    onPressed: () async {
                      bool isMinimized = await windowManager.isMinimized();
                      if (isMinimized) {
                        await windowManager.restore();
                      } else {
                        await windowManager.minimize();
                      }
                    },
                  ),
                  WindowCaptionButton.close(
                    onPressed: () async {
                      // Сохраняем ширину и высоту окна для использования при перезапуске программы
                      final size = await windowManager.getSize();
                      final width = await ref.read(storageProvider).get<double>(KeyStore.windowWidth);
                      final height = await ref.read(storageProvider).get<double>(KeyStore.windowHeight);
                      // Сохраняем, только если значения изменились
                      if (width != size.width) {
                        await ref.read(storageProvider).set<double>(KeyStore.windowWidth, size.width);
                      }
                      if (height != size.height) {
                        await ref.read(storageProvider).set<double>(KeyStore.windowHeight, size.height);
                      }

                      // Получим и сохраним положение окна на экране монитора
                      final position = await windowManager.getPosition();
                      final dx = await ref.read(storageProvider).get<double>(KeyStore.offsetX);
                      final dy = await ref.read(storageProvider).get<double>(KeyStore.offsetY);
                      // Сохраняем, только если значения изменились
                      if (dx != position.dx) {
                        await ref.read(storageProvider).set<double>(KeyStore.offsetX, position.dx);
                      }
                      if (dy != position.dy) {
                        await ref.read(storageProvider).set<double>(KeyStore.offsetY, position.dy);
                      }

                      await windowManager.close();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getAppBarTitle() {
    return DragToMoveArea(
      child: Container(
        height: kWindowCaptionHeight,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kWindowCaptionHeight);
}
