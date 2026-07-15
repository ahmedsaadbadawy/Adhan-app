enum DeepLinkType { quran, prayerTimes }

extension DeepLinkTypeExtension on DeepLinkType {
  String get host {
    switch (this) {
      case DeepLinkType.quran:
        return 'quran';

      case DeepLinkType.prayerTimes:
        return 'prayer-times';
    }
  }

  static DeepLinkType? fromUri(Uri uri) {
    for (final item in DeepLinkType.values) {
      if (item.host == uri.host) {
        return item;
      }
    }

    return null;
  }
}
