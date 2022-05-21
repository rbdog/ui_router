//
//
//

import 'package:flutter/material.dart';

/// a Page
class UiPage<PageId> {
  final PageId id;
  final Widget Function(Map<String, String> params) build;

  /// Constructor
  const UiPage({
    required this.id,
    required this.build,
  });
}
