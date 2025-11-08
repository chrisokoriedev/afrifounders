import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Theme box name for Hive
const String themeBoxName = 'theme';

/// Theme mode provider with persistence
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  bool build() {
    // Load theme preference from Hive
    final box = Hive.box(themeBoxName);
    return box.get('isDarkMode', defaultValue: false) as bool;
  }

  /// Toggle theme mode
  void toggleTheme() {
    final newValue = !state;
    state = newValue;
    // Persist theme preference
    final box = Hive.box(themeBoxName);
    box.put('isDarkMode', newValue);
  }

  /// Set theme mode
  void setTheme(bool isDark) {
    state = isDark;
    final box = Hive.box(themeBoxName);
    box.put('isDarkMode', isDark);
  }
}

