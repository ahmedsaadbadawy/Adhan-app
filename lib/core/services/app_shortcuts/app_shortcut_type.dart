enum AppShortcutType { prayerTimes, quran }

extension AppShortcutTypeExtension on AppShortcutType {
  String get type {
    switch (this) {
      case AppShortcutType.prayerTimes:
        return 'prayer_times';

      case AppShortcutType.quran:
        return 'quran';
    }
  }

  static AppShortcutType? fromType(String value) {
    for (final item in AppShortcutType.values) {
      if (item.type == value) {
        return item;
      }
    }

    return null;
  }
}
