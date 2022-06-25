//
//
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/ui_state.dart';

/// UiNotifier
class UiNotifier<PageId> extends ChangeNotifier {
  UiState<PageId> state;
  void Function() willDispose;
  UiNotifier(this.state, this.willDispose);

  /// update the state
  update(UiState<PageId> newState) {
    state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    willDispose();
    super.dispose();
  }
}
