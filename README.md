![Header](https://github.com/rbdog/ui_router/blob/main/resources/images/ui-router-header.png?raw=true)

# Simple UI Router

https://pub.dev/packages/ui_router

## router

```
final router = UiRouter(
  pages: [
    UiPage(
      id: 'A',
      build: (params) => PageA(),
    ),
    UiPage(
      id: 'B',
      build: (params) => PageB(params['message']),
    ),
    // ...this is all pages in my app
  ],
);
```

## use as a widget (start with page A)

```
router.widget()
```

## push (go to page B)

```
router.push('B');
```

## push with params

```
router.push('B', params: {'message': 'HELLO😁'});
```

## pop (back one page)

```
router.pop();
```

## pop until the specified page

```
router.popTo('O');
```

## do something before every push

```
router.willPush((left, right) {
  // always allow push
  return true;
});
```

## do something before every pop

```
router.willPop((left, right) {
  // always allow pop
  return true;
});
```

## see the page IDs stack

```
print(router.stack());
```

😄 Using Navigator 2.0\
🎉 Contributions are welcomed!
