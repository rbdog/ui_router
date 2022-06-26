//
//
//

import 'package:flutter/material.dart';
import 'package:ui_router/src/provider.dart';

class TabState<PageId> {
  final PageId tabPageId;

  const TabState({
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

/// Notifier for Tab Pages
class TabNotifier<PageId> extends ChangeNotifier {
  TabState<PageId> _state;
  void Function() willDispose;
  TabNotifier(this._state, this.willDispose);

  /// update the state
  update(TabState<PageId> newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    willDispose();
    super.dispose();
  }

  /// Switch Tab
  select(PageId tabPageId) {
    _state = TabState(tabPageId: tabPageId);
    notifyListeners();
  }
}

/// Router for Tab Pages
class TabRouter<PageId> {
  PageId initialTabPageId;
  final List<TabPage<PageId>> tabPages;
  TabNotifier<PageId>? _notifier;
  Widget? _cacheWidget;
  void Function(String log) _logger = (String log) {};

  /// Constructor
  TabRouter({
    required this.initialTabPageId,
    required this.tabPages,
  });

  // Widget to show
  Widget widget({bool enableMaterialYou = false}) {
    // Create if not exist
    if (_cacheWidget == null) {
      _logger('init Widget');
      // notifier を初期化
      _notifier = TabNotifier<PageId>(
        TabState(tabPageId: initialTabPageId),
        _willDispose,
      );
      _cacheWidget = _RouterWidget<PageId>(
        this,
        enableMaterialYou: enableMaterialYou,
      );
    }
    return _cacheWidget!;
  }

  /// Tab Page ID
  PageId tabPageId() {
    if (_notifier == null) {
      throw Exception('cannot read tab nefore widget appear');
    }
    return _notifier!._state.tabPageId;
  }

  /// Switch Tab
  select(PageId tabPageId) {
    if (_notifier == null) return;
    _notifier!.select(tabPageId);
  }

  _willDispose() {
    _cacheWidget = null;
  }
}

class _RouterWidget<PageId> extends StatelessWidget {
  final TabRouter<PageId> _router;
  final bool enableMaterialYou;

  const _RouterWidget(
    this._router, {
    this.enableMaterialYou = false,
  });

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
    final consumer = Consumer<TabNotifier<PageId>>(
      builder: (context, r, child) {
        /// 画面下のバー
        var naviBar = BottomNavigationBar(
          items: [
            for (var page in _router.tabPages)
              BottomNavigationBarItem(icon: page.tabIcon, label: page.tabLabel),
          ],
          currentIndex:
              _router.tabPages.indexWhere((p) => p.id == _router.tabPageId()),
          onTap: (i) => _onItemTapped(_router, i),
          type: BottomNavigationBarType.fixed,
        );

        /// マテリアルYou
        var naviBarYou = NavigationBar(
          destinations: [
            for (var page in _router.tabPages)
              NavigationDestination(
                icon: page.tabIcon,
                label: page.tabLabel,
              ),
          ],
          selectedIndex:
              _router.tabPages.indexWhere((p) => p.id == _router.tabPageId()),
          onDestinationSelected: (i) => _onItemTapped(_router, i),
        );

        /// 画面
        return Scaffold(
          body: buildPage(_router, _router.tabPageId()),
          bottomNavigationBar: enableMaterialYou ? naviBarYou : naviBar,
        );
      },
    );

    return ChangeNotifierProvider(
      create: (context) {
        return _router._notifier!;
      },
      child: consumer,
    );
  }
}
