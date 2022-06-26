import 'dart:async';

import 'package:ui_router/src/ui_dialog_answer.dart';

// dialog answer type
enum UiAnswerType {
  ok,
  cancel,
  params,
}

class UiDialogCompleter {
  final completer = Completer<UiDialogAnswer>();

  /// DONT CALL this from Dialog
  Future<UiDialogAnswer> getAnswer() async {
    return completer.future;
  }

  /// complete dialog with OK answer
  ok() {
    final answer = UiDialogAnswer(type: UiAnswerType.ok, params: {});
    completer.complete(answer);
  }

  /// complete dialog with Cancel answer
  cancel() {
    final answer = UiDialogAnswer(type: UiAnswerType.cancel, params: {});
    completer.complete(answer);
  }

  /// complete dialog with Params answer
  params(Map<String, dynamic> params) {
    final answer = UiDialogAnswer(type: UiAnswerType.params, params: params);
    completer.complete(answer);
  }
}
