//
//
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/provider.dart';
import 'package:ui_router/src/ui_element.dart';
import 'package:ui_router/src/ui_notifier.dart';
import 'package:ui_router/ui_router.dart';

/// UiRouterWidget
class UiRouterWidget<PageId> extends StatelessWidget {
  final UiNotifier<PageId> notifier;
  final List<UiPage> pages;
  final void Function() onPressPop;
  const UiRouterWidget({
    required this.notifier,
    required this.pages,
    required this.onPressPop,
    Key? key,
  }) : super(key: key);

  Widget buildPage(UiElement ele) {
    final page = pages.cast<UiPage<PageId>?>().firstWhere(
          (p) => p?.id == ele.pageId,
          orElse: () => null,
        );
    if (page != null) {
      return page.build(ele.params);
    } else {
      return Text(
        'Not found UiPage for id: ${ele.pageId}. Please add to this router',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Consumer<UiNotifier<PageId>>(
      builder: (context, notifier, _) {
        final navigator = Navigator(
          pages: [
            for (var ele in notifier.state.elements)
              MaterialPage(
                child: buildPage(ele),
              ),
          ],
          onPopPage: (route, result) {
            onPressPop();
            return false; // disable pop of the framework
          },
        );

        final scaffold = Scaffold(body: navigator);
        return scaffold;
      },
    );

    return consumer;
  }
}
