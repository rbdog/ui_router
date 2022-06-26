//
//
//

import 'package:ui_router/src/loading_task.dart';
import 'package:ui_router/src/ui_element.dart';

/// UiState
class UiState<PageId, DialogId> {
  final List<UiElement<PageId>> elements;
  final List<UiElement<DialogId>> dialogElements;
  final List<LoadingTask> tasks;

  UiState({
    required this.elements,
    required this.dialogElements,
    required this.tasks,
  });
}
