# local_assets_server

HTTP Server which serves local assets

![GitHub stars](https://img.shields.io/github/stars/lesnitsky/flutter_local_assets_server.svg?style=social)
![Twitter Follow](https://img.shields.io/twitter/follow/lesnitsky_a.svg?label=Follow%20me&style=social)

## Installation

```yml
dependencies:
  local_assets_server: ^1.0.1
```

```sh
flutter packages get
```

## Usage

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:local_assets_server/local_assets_server.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isListening;

  @override
  initState() {
    isListening = false;
    _initServer();

    super.initState();
  }

  _initServer() async {
    final server = new LocalAssetsServer(
      address: InternetAddress.anyIPv4,
      assetsBasePath: 'web/dist/',
      port: 9090,
    );

    await server.serve();

    setState(() {
      isListening = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: isListening
            ? WebView(
                javascriptMode: JavascriptMode.unrestricted,
                debuggingEnabled: true,
                initialUrl: 'http://127.0.0.1:42152',
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

```

## LICENSE

MIT
