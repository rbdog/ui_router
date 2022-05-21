//
//
//

import 'package:ui_router/src/ui_element.dart';

/// UiState
class UiState<PageId> {
  final List<UiElement<PageId>> elements;

  const UiState({
    required this.elements,
  });
}
