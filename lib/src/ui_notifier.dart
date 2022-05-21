//
//
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/ui_state.dart';

/// UiNotifier
class UiNotifier<PageId> extends ChangeNotifier {
  UiState<PageId> state;
  UiNotifier(this.state);

  /// update the state
  update(UiState<PageId> newState) {
    state = newState;
    notifyListeners();
  }
}
