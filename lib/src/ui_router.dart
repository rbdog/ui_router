//
//
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/provider.dart';
import 'package:ui_router/src/ui_element.dart';
import 'package:ui_router/src/ui_notifier.dart';
import 'package:ui_router/src/ui_page.dart';
import 'package:ui_router/src/ui_router_widget.dart';
import 'package:ui_router/src/ui_state.dart';

/// Router for App UI
class UiRouter<PageId> {
  final List<UiPage<PageId>> pages;
  final UiNotifier<PageId> _notifier;
  Widget? _cacheWidget;
  // ignore: prefer_function_declarations_over_variables
  var _allowPush = (PageId left, PageId right) => true;
  // ignore: prefer_function_declarations_over_variables
  var _allowPop = (PageId left, PageId right) => true;

  /// Constructor
  UiRouter({
    required this.pages,
    PageId? initialPageId,
  }) : _notifier = UiNotifier<PageId>(
          UiState<PageId>(
            elements: [
              UiElement(
                pageId: initialPageId ?? pages.first.id,
                params: {},
              ),
            ],
          ),
        );

  // Widget to show
  Widget widget() {
    // Create if not exist
    _cacheWidget ??= ChangeNotifierProvider(
      create: (context) {
        return _notifier;
      },
      child: UiRouterWidget<PageId>(
        notifier: _notifier,
        pages: pages,
        onPressPop: pop,
      ),
    );
    return _cacheWidget!;
  }

  /// Go to the next page
  push(
    PageId pageId, {
    Map<String, String> params = const {},
  }) {
    final allowPush = _allowPush(_notifier.state.elements.last.pageId, pageId);
    if (!allowPush) return;
    final idParams = UiElement(pageId: pageId, params: params);
    final newState = UiState(elements: [..._notifier.state.elements, idParams]);
    _notifier.update(newState);
  }

  /// Back one page
  pop() {
    if (_notifier.state.elements.length <= 1) return;
    final right = _notifier.state.elements.last.pageId;
    final left =
        _notifier.state.elements[_notifier.state.elements.length - 2].pageId;
    final allowPop = _allowPop(left, right);
    if (!allowPop) return;
    final newState = UiState(elements: _notifier.state.elements..removeLast());
    _notifier.update(newState);
  }

  /// Back some pages
  popTo(PageId id) {
    final index = _notifier.state.elements.indexWhere((e) => e.pageId == id);
    if (index < 0) return;
    final right = _notifier.state.elements.last.pageId;
    final left = _notifier.state.elements[index].pageId;
    final allowPop = _allowPop(left, right);
    if (!allowPop) return;
    final newStack = _notifier.state.elements.sublist(0, index);
    final newState = UiState(elements: newStack);
    _notifier.update(newState);
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
  List<PageId> stack() {
    return _notifier.state.elements.map((e) => e.pageId).toList();
  }
}
