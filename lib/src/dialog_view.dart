import 'package:flutter/material.dart';
import 'package:ui_router/src/ui_dialog.dart';
import 'package:ui_router/src/ui_element.dart';

/// DialogView
class DialogView extends StatelessWidget {
  final List<UiElement> dialogElements; // 表示したいダイアログ
  final List<UiDialog> dialogs; // 全てのダイアログ
  const DialogView({
    Key? key,
    required this.dialogs,
    required this.dialogElements,
  }) : super(key: key);

  Widget buildDialog(UiElement ele) {
    final dialog = dialogs.cast<UiDialog?>().firstWhere(
          (d) => d?.id == ele.pageId,
          orElse: () => null,
        );
    if (dialog != null) {
      return dialog.build(
        ele.params,
        ele.completer!, // Dialog must have completer
      );
    } else {
      return Text(
        'Not found UiDialog for id: ${ele.pageId}. Please add to this router',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dialogElements.isEmpty) {
      return const SizedBox.shrink();
    }

    final dialogNavigator = Navigator(
      pages: [
        for (var ele in dialogElements.reversed)
          MaterialPage(
            child: Center(
              child: buildDialog(ele),
            ),
          ),
      ],
      onPopPage: (route, result) {
        return false; // disable pop of the framework
      },
    );

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2), //この行を追加
            ),
            alignment: Alignment.center,
            child: dialogNavigator,
          ),
        ),
      ],
    );
  }
}
