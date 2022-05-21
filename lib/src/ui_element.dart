//
//
//

/// UiElement  = ID & Params
class UiElement<PageId> {
  final PageId pageId;
  final Map<String, String> params;
  UiElement({
    required this.pageId,
    required this.params,
  });
}
