//
// 自作のルーターライブラリ
// パッケージ依存を減らすために作成
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/provider.dart';

class _Element<PageId> {
  final PageId pageId;
  final Map<String, String> params;
  _Element({
    required this.pageId,
    required this.params,
  });
}

class _State<PageId> {
  final List<_Element<PageId>> stack;

  const _State({
    required this.stack,
  });
}

/// a Page
class UiPage<PageId> {
  final PageId id;
  final Widget Function(Map<String, String> params) build;

  /// Constructor
  const UiPage({
    required this.id,
    required this.build,
  });
}

class _RouterWidget<PageId> extends StatelessWidget {
  final UiRouter<PageId> _router;
  // ignore: use_key_in_widget_constructors
  const _RouterWidget(this._router);

  Widget buildPage(UiRouter<PageId> r, _Element ele) {
    final page = r.pages.cast<UiPage<PageId>?>().firstWhere(
          (p) => p?.id == ele.pageId,
          orElse: () => null,
        );
    if (page != null) {
      return page.build(ele.params);
    } else {
      throw Exception('${ele.pageId} に対応するページをルーターに登録してください');
    }
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Consumer<UiRouter<PageId>>(
      builder: (context, r, child) {
        final navigator = Navigator(
          pages: [
            for (var ele in r.stack())
              MaterialPage(
                child: buildPage(r, ele),
              ),
          ],
          onPopPage: (route, result) {
            r.pop();
            return false; // フレームワークの pop は無効化
          },
        );

        final scaffold = Scaffold(body: navigator);
        return scaffold;
      },
    );

    return ChangeNotifierProvider(
      create: (context) {
        return _router;
      },
      child: consumer,
    );
  }
}

/// Router for App UI
class UiRouter<PageId> extends ChangeNotifier {
  final List<UiPage<PageId>> pages;
  _State<PageId> _state;
  Widget? cacheWidget;
  // ignore: prefer_function_declarations_over_variables
  var _allowPush = (PageId left, PageId right) => true;
  // ignore: prefer_function_declarations_over_variables
  var _allowPop = (PageId left, PageId right) => true;

  /// Constructor
  UiRouter({
    required this.pages,
    PageId? initialPageId,
  }) : _state = _State(
          stack: [
            _Element(
              pageId: initialPageId ?? pages.first.id,
              params: {},
            ),
          ],
        );

  // Widget to show
  Widget widget() {
    cacheWidget ??= _RouterWidget<PageId>(this);
    return cacheWidget!;
  }

  /// Go to the next page
  push(
    PageId pageId, {
    Map<String, String> params = const {},
  }) {
    final allowPush = _allowPush(_state.stack.last.pageId, pageId);
    if (!allowPush) return;
    final idParams = _Element(pageId: pageId, params: params);
    _state = _State(stack: [..._state.stack, idParams]);
    notifyListeners();
  }

  /// Back one page
  pop() {
    if (_state.stack.length <= 1) return;
    final right = _state.stack.last.pageId;
    final left = _state.stack[_state.stack.length - 2].pageId;
    final allowPop = _allowPop(left, right);
    if (!allowPop) return;
    _state = _State(stack: _state.stack..removeLast());
    notifyListeners();
  }

  /// Back some pages
  popTo(PageId id) {
    final index = _state.stack.indexWhere((e) => e.pageId == id);
    if (index < 0) return;
    final right = _state.stack.last.pageId;
    final left = _state.stack[index].pageId;
    final allowPop = _allowPop(left, right);
    if (!allowPop) return;
    final newStack = _state.stack.sublist(0, index);
    _state = _State(stack: newStack);
    notifyListeners();
  }

  /// Called when push
  /// You can cancel if needed
  /// Push from the left to the right
  willPush(bool Function(PageId left, PageId right) allowPush) {
    _allowPush = allowPush;
  }

  /// Called when pop
  /// You can cancel if needed
  /// Pop from the right to the left
  willPop(bool Function(PageId left, PageId right) allowPop) {
    _allowPop = allowPop;
  }

  /// See the Page history
  List<_Element<PageId>> stack() {
    return _state.stack;
  }
}
