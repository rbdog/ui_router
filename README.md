# Super Simple, Minimal, Lightweight Router.

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

## push (go to Page B)

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
