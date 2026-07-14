import 'package:quick_actions/quick_actions.dart';

import 'app_shortcut_type.dart';

class AppShortcutsService {
  AppShortcutsService();

  final QuickActions _quickActions = const QuickActions();

  AppShortcutType? _pendingShortcut;

  Future<void> init() async {
    await _quickActions.initialize((String shortcutType) {
      _pendingShortcut = AppShortcutTypeExtension.fromType(shortcutType);
    });

    await _setStaticShortcuts();
  }

  Future<void> _setStaticShortcuts() async {
    await _quickActions.setShortcutItems([
      const ShortcutItem(
        type: 'prayer_times',
        localizedTitle: 'Prayer Times',
        icon: 'ic_prayer',
      ),
      const ShortcutItem(
        type: 'quran',
        localizedTitle: 'Quran',
        icon: 'ic_book',
      ),
    ]);
  }

  AppShortcutType? consumeShortcut() {
    final shortcut = _pendingShortcut;
    _pendingShortcut = null;
    return shortcut;
  }
}
