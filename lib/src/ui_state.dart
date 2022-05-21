//
//
//

import 'package:ui_router/src/loading_task.dart';
import 'package:ui_router/src/ui_element.dart';

/// UiState
class UiState<PageId> {
  final List<UiElement<PageId>> elements;
  final List<LoadingTask> tasks;

  UiState({
    required this.elements,
    required this.tasks,
  });
}
