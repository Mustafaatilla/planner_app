import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeType _currentTheme = ThemeType.light;

  ThemeType get currentTheme => _currentTheme;

  // Helper to get the actual ThemeData
  ThemeData get themeData => AppTheme.getTheme(_currentTheme);

  ThemeProvider() {
    _loadTheme();
  }

  void setTheme(ThemeType type) async {
    _currentTheme = type;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_type', type.toString());
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('theme_type');
    if (themeString != null) {
      _currentTheme = ThemeType.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeType.light,
      );
      notifyListeners();
    }
  }
}
