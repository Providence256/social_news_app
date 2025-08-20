import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/services/preferences_service.dart';
import 'package:social_media_app/utils/theme/app_theme.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(AppTheme.lightTheme) {
    _loadTheme();
  }

  static const String _themeKey = 'app_theme';

  Future<void> _loadTheme() async {
    final isDark = PreferencesService.getBool(_themeKey);
    state = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  Future<void> toggleTheme() async {
    final isDark = state.brightness == Brightness.dark;

    if (isDark) {
      state = AppTheme.lightTheme;
      await PreferencesService.setBool(_themeKey, false);
    } else {
      state = AppTheme.darkTheme;
      await PreferencesService.setBool(_themeKey, true);
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
