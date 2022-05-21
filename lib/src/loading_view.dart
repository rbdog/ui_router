import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final bool isLoading;
  const LoadingView(this.isLoading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), //この行を追加
                  ),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              )
            ],
          )
        : Column(
            children: const [],
          );
  }
}
