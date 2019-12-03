import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

import 'package:flutter/services.dart';

class AssetsCache {
  /// Assets cache
  static Map<String, ByteData> assets = {};

  /// Clears assets cache
  static void clear() {
    assets = {};
  }
}

class LocalAssetsServer {
  /// Server address
  InternetAddress address;

  /// Optional server port (note: might be already taken)
  /// Defaults to 0 (binds server to a random free port)
  int port;

  /// Assets base path
  String assetsBasePath;

  HttpServer _server;

  LocalAssetsServer({
    @required this.address,
    @required this.assetsBasePath,
    this.port = 0,
  }) {
    assert(address != null);
    assert(port != null);
    assert(assetsBasePath != null);
  }

  /// Actual port server is listening on
  get boundPort => _server.port;

  /// Starts server
  Future<InternetAddress> serve({bool shared = false}) async {
    _server = await HttpServer.bind(this.address, this.port, shared: shared);
    _server.listen(_handleReq);
    return _server.address;
  }

  _handleReq(HttpRequest request) async {
    String path = request.requestedUri.path.replaceFirst('/', '');

    if (path == '') {
      path = 'index.html';
    }

    try {
      final data = await _loadAsset(path);
      final name = basename(path);
      final mime = lookupMimeType(name);

      request.response.headers.add('Content-Type', '$mime; charset=utf-8');
      request.response.add(data.buffer.asUint8List());

      request.response.close();
    } catch (err) {
      request.response.statusCode = 404;
      request.response.close();
    }
  }

  Future<ByteData> _loadAsset(String path) async {
    if (AssetsCache.assets.containsKey(path)) {
      return AssetsCache.assets[path];
    } else {
      ByteData data = await rootBundle.load(join(assetsBasePath, path));
      AssetsCache.assets[path] = data;
      return data;
    }
  }
}
