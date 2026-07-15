import 'dart:async';

import 'package:app_links/app_links.dart';

import 'deep_link_type.dart';

class DeepLinksService {
  DeepLinksService();

  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  DeepLinkType? _pendingDeepLink;

  Future<void> init() async {
    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      _pendingDeepLink = DeepLinkTypeExtension.fromUri(initialUri);
    }

    _subscription = _appLinks.uriLinkStream.listen((uri) {
      _pendingDeepLink = DeepLinkTypeExtension.fromUri(uri);
    });
  }

  DeepLinkType? consumeDeepLink() {
    final deepLink = _pendingDeepLink;
    _pendingDeepLink = null;
    return deepLink;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
