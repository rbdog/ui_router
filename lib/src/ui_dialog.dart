//
//
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/ui_dialog_completer.dart';

/// a Dialog
class UiDialog<DialogId> {
  final DialogId id;
  final Widget Function(
    Map<String, String> params,
    UiDialogCompleter completer,
  ) build;

  /// Constructor
  const UiDialog({
    required this.id,
    required this.build,
  });
}
