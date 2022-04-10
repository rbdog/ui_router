import 'package:flutter/material.dart';
import 'package:ui_router/ui_router.dart';

void main() {
  runApp(App());
}

//
//  'String' or 'Enum' , any type Page ID
//
enum Pages {
  A,
  B,
}

//
//  router
//
final router = UiRouter(
  initialPageId: Pages.A,
  pages: [
    //
    // Add all pages here.
    //
    UiPage(
      id: Pages.A,
      build: (params) => PageA(),
    ),
    UiPage(
      id: Pages.B,
      build: (params) => PageB(params['message']),
    ),
  ],
);

//
//  Your App
//
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //
      //  Display as a Widget
      //
      home: router.widget(),
    );
  }
}

//
//  Page A
//
class PageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('This is A')),
      body: ElevatedButton(onPressed: pushToB, child: Text('Push To B')),
    );
  }

  pushToB() {
    router.push(Pages.B, params: {'message': 'HELLO😁'});
  }
}

//
//  Page B
//
class PageB extends StatelessWidget {
  final String? message;
  PageB(this.message);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('This is B')),
      body: Text('received message: $message'),
    );
  }
}
