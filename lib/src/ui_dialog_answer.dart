//
//
//

import 'package:ui_router/src/ui_dialog_completer.dart';

// Answer from a dialog
class UiDialogAnswer {
  final UiAnswerType type;
  final Map<String, dynamic> params;
  UiDialogAnswer({
    required this.type,
    required this.params,
  });
}
