//
//
//

/// LoadingTask
class LoadingTask {
  /// Message Label
  final String label;

  /// Task Process
  final Function() action;
  const LoadingTask({
    required this.label,
    required this.action,
  });
}
