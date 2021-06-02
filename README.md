# local_assets_server

[![lesnitsky.dev](https://lesnitsky.dev/shield.svg?hash=120246)](https://lesnitsky.dev?utm_source=local_assets_server)
[![GitHub stars](https://img.shields.io/github/stars/lesnitsky/local_assets_server.svg?style=social)](https://github.com/lesnitsky/local_assets_server)
[![Twitter Follow](https://img.shields.io/twitter/follow/lesnitsky_dev.svg?label=Follow%20me&style=social)](https://twitter.com/lesnitsky_dev)

HTTP Server which serves local assets

## Installation

pubspec.yaml:

```yaml
dependencies:
  local_assets_server: ^2.0.2+10
```

## Example

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_assets_server/local_assets_server.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Assets Server Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Local Assets Server Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isListening = false;
  String? address;
  int? port;
  WebViewController? controller;

  void _incrementCounter() {
    controller?.evaluateJavascript('window.increment()');
  }

  @override
  initState() {
    _initServer();
    super.initState();
  }

  _initServer() async {
    final server = new LocalAssetsServer(
      address: InternetAddress.loopbackIPv4,
      assetsBasePath: 'web',
      logger: DebugLogger(),
    );

    final address = await server.serve();

    setState(() {
      this.address = address.address;
      port = server.boundPort!;
      isListening = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isListening
          ? WebView(
              debuggingEnabled: true,
              initialUrl: 'http://$address:$port',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (c) {
                controller = c;
              },
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

```

## License

MIT
