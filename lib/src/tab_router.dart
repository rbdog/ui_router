//
//
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/provider.dart';

class _State<PageId> {
  final PageId tabPageId;

  const _State({
    required this.tabPageId,
  });
}

/// Tab Page
class TabPage<PageId> {
  final PageId id;
  final Widget tabIcon;
  final String tabLabel;
  final Widget Function() build;
  const TabPage({
    required this.id,
    required this.tabIcon,
    required this.tabLabel,
    required this.build,
  });
}

/// Router for Tab Pages
class TabRouter<PageId> extends ChangeNotifier {
  _State<PageId> _state;
  final List<TabPage<PageId>> tabPages;
  Widget? cacheWidget;

  /// Constructor
  TabRouter({
    required PageId initialTabPageId,
    required this.tabPages,
  }) : _state = _State(tabPageId: initialTabPageId);

  /// Tab Router Widget
  Widget widget() {
    cacheWidget ??= _RouterWidget<PageId>(this);
    return cacheWidget!;
  }

  /// Tab Page ID
  PageId tabPageId() {
    return _state.tabPageId;
  }

  /// Switch Tab
  select(PageId tabPageId) {
    _state = _State(tabPageId: tabPageId);
    notifyListeners();
  }
}

class _RouterWidget<PageId> extends StatelessWidget {
  final TabRouter<PageId> _router;
  // ignore: use_key_in_widget_constructors
  const _RouterWidget(this._router);

  Widget buildPage(TabRouter<PageId> r, PageId tabPageId) {
    final page = r.tabPages.cast<TabPage<PageId>?>().firstWhere(
          (p) => p?.id == tabPageId,
          orElse: () => null,
        );
    if (page != null) {
      return page.build();
    } else {
      throw Exception('$tabPageId に対応するタブをルーターに登録してください');
    }
  }

  /// タブをタップされたとき
  void _onItemTapped(TabRouter r, int index) {
    final tabPage = r.tabPages[index];
    r.select(tabPage.id);
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Consumer<TabRouter<PageId>>(
      builder: (context, r, child) {
        /// 画面下のバー
        var naviBar = BottomNavigationBar(
          items: [
            for (var page in r.tabPages)
              BottomNavigationBarItem(icon: page.tabIcon, label: page.tabLabel),
          ],
          currentIndex: r.tabPages.indexWhere((p) => p.id == r.tabPageId()),
          onTap: (i) => _onItemTapped(r, i),
          type: BottomNavigationBarType.fixed,
        );

        /// 画面
        return Scaffold(
          body: buildPage(r, r.tabPageId()),
          bottomNavigationBar: naviBar,
        );
      },
    );

    return ChangeNotifierProvider(
      create: (context) {
        return _router;
      },
      child: consumer,
    );
  }
}
