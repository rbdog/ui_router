//
//
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/loading_task.dart';
import 'package:ui_router/src/provider.dart';
import 'package:ui_router/src/ui_dialog_completer.dart';
import 'package:ui_router/src/ui_dialog.dart';
import 'package:ui_router/src/ui_dialog_answer.dart';
import 'package:ui_router/src/ui_element.dart';
import 'package:ui_router/src/ui_notifier.dart';
import 'package:ui_router/src/ui_page.dart';
import 'package:ui_router/src/ui_router_widget.dart';
import 'package:ui_router/src/ui_state.dart';

/// Router for App UI
class UiRouter<PageId, DialogId> {
  final List<UiPage<PageId>> pages;
  final List<UiDialog<DialogId>> dialogs;
  UiNotifier<PageId, DialogId>? _notifier;
  Widget? _cacheWidget;
  PageId? initialPageId;
  // ignore: prefer_function_declarations_over_variables
  var _allowPush = (PageId left, PageId right) => true;
  // ignore: prefer_function_declarations_over_variables
  var _allowPop = (PageId left, PageId right) => true;
  // ignore: prefer_function_declarations_over_variables
  void Function(String log) _logger = (String log) {};

  /// Constructor
  UiRouter({
    required this.pages,
    this.dialogs = const [],
    this.initialPageId,
  });

  // Widget to show
  Widget widget() {
    // Create if not exist
    if (_cacheWidget == null) {
      _logger('init Widget');
      // notifier を初期化
      _notifier = UiNotifier<PageId, DialogId>(
        UiState<PageId, DialogId>(
          elements: [
            UiElement(
              pageId: initialPageId ?? pages.first.id,
              params: {},
              completer: null,
            ),
          ],
          dialogElements: [],
          tasks: [],
        ),
        _willDisappearWidget,
      );
      _cacheWidget = ChangeNotifierProvider(
        create: (context) {
          return _notifier!;
        },
        child: UiRouterWidget<PageId, DialogId>(
          notifier: _notifier!, // 表示前に呼ぶとクラッシュ
          pages: pages,
          dialogs: dialogs,
          onPressPop: pop,
        ),
      );
    }
    return _cacheWidget!;
  }

  /// willDisappesrWidget
  _willDisappearWidget() {
    _logger('Clear Widget cache');
    _cacheWidget = null;
  }

  /// Go to the next page
  push(
    PageId pageId, {
    Map<String, String> params = const {},
  }) {
    if (_notifier == null) return;
    final allowPush = _allowPush(_notifier!.state.elements.last.pageId, pageId);
    if (!allowPush) return;
    final idParams = UiElement(
      pageId: pageId,
      params: params,
      completer: null,
    );
    final newState = UiState(
      elements: [..._notifier!.state.elements, idParams],
      dialogElements: _notifier!.state.dialogElements,
      tasks: _notifier!.state.tasks,
    );
    _notifier!.update(newState);
  }

  /// Back one page
  pop() {
    if (_notifier == null) return;
    if (_notifier!.state.elements.length <= 1) return;
    final right = _notifier!.state.elements.last.pageId;
    final left =
        _notifier!.state.elements[_notifier!.state.elements.length - 2].pageId;
    final allowPop = _allowPop(left, right);
    if (!allowPop) return;
    final newState = UiState(
      elements: _notifier!.state.elements..removeLast(),
      dialogElements: _notifier!.state.dialogElements,
      tasks: _notifier!.state.tasks,
    );
    _notifier!.update(newState);
  }

  /// Back some pages
  popTo(PageId id) {
    if (_notifier == null) return;
    final index = _notifier!.state.elements.indexWhere((e) => e.pageId == id);
    if (index < 0) return;
    final right = _notifier!.state.elements.last.pageId;
    final left = _notifier!.state.elements[index].pageId;
    final allowPop = _allowPop(left, right);
    if (!allowPop) return;
    final newStack = _notifier!.state.elements.sublist(0, index + 1);
    final newState = UiState(
      elements: newStack,
      dialogElements: _notifier!.state.dialogElements,
      tasks: _notifier!.state.tasks,
    );
    _notifier!.update(newState);
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

  /// watch log
  setLogger(void Function(String log) logger) {
    _logger = logger;
  }

  /// See the Page history
  List<PageId> stack() {
    if (_notifier == null) return [];
    return _notifier!.state.elements.map((e) => e.pageId).toList();
  }

  /// Show loading with a task
  loading({
    required String label,
    required Function() task,
  }) async {
    if (_notifier == null) return;
    final loadingTask = LoadingTask(label: label, action: task);
    final preState = UiState(
      elements: _notifier!.state.elements,
      dialogElements: _notifier!.state.dialogElements,
      tasks: [..._notifier!.state.tasks, loadingTask],
    );
    _notifier!.update(preState);
    // await task action
    await loadingTask.action();
    final postState = UiState(
      elements: _notifier!.state.elements,
      dialogElements: _notifier!.state.dialogElements,
      tasks: _notifier!.state.tasks..remove(loadingTask),
    );
    _notifier!.update(postState);
  }

  /// show Dialog
  Future<UiDialogAnswer> enqDialog(
    DialogId dialogId, {
    Map<String, String> params = const {},
  }) async {
    if (_notifier == null) throw Exception('_notifier is null');
    final completer = UiDialogCompleter();
    final idParams =
        UiElement(pageId: dialogId, params: params, completer: completer);
    final newState = UiState(
      elements: _notifier!.state.elements,
      dialogElements: [..._notifier!.state.dialogElements, idParams],
      tasks: _notifier!.state.tasks,
    );
    _notifier!.update(newState);
    return await completer.getAnswer();
  }

  // hide dialog
  deqDialog() {
    if (_notifier == null) return;
    final newState = UiState(
      elements: _notifier!.state.elements,
      dialogElements: _notifier!.state.dialogElements..removeLast(),
      tasks: _notifier!.state.tasks,
    );
    _notifier!.update(newState);
  }
}
