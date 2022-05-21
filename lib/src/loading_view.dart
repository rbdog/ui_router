import 'package:flutter/material.dart';
import 'package:ui_router/src/loading_task.dart';

/// LoadingView
class LoadingView extends StatelessWidget {
  final List<LoadingTask> tasks;
  const LoadingView(this.tasks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tasks.isNotEmpty
        ? Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2), //この行を追加
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const CircularProgressIndicator(),
                        Text(tasks.last.label),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        : Column(
            children: const [],
          );
  }
}
