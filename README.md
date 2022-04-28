![Header](https://github.com/rbdog/ui_router/blob/main/resources/images/ui-router-header.png?raw=true)

# Super Simple Router

https://pub.dev/packages/ui_router

## router

```
final router = UiRouter(
  initialPageId: 'A',
  pages: [
    UiPage(
      id: 'A',
      build: (params) => PageA(),
    ),
    UiPage(
      id: 'B',
      build: (params) => PageB(params['message']),
    ),
  ],
);
```

## widget

```
router.widget()
```

## push

```
router.push('B');
```

## push with params

```
router.push('B', params: {'message': 'HELLO😁'});
```

## back to the page

```
router.pop();
```

✨ Using Navigator 2.0 ✨
