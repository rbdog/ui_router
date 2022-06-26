//
//
//

import 'package:ui_router/src/ui_dialog_completer.dart';

/// UiElement  = ID & Params
class UiElement<PageId> {
  final PageId pageId;
  final Map<String, String> params;
  final UiDialogCompleter? completer;
  UiElement({
    required this.pageId,
    required this.params,
    required this.completer,
  });
}
