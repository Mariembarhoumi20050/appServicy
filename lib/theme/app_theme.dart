import 'package:flutter/material.dart';

class AppThemeController extends ChangeNotifier {
  static final AppThemeController instance = AppThemeController._();

  AppThemeController._();

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggle() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get lightTheme {
    const Color brandCopper = Color(0xFFB87435);
    const Color brandDeep = Color(0xFF2F3E46);

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandCopper,
        brightness: Brightness.light,
      ).copyWith(
        primary: brandCopper,
        secondary: const Color(0xFFE3A46B),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: brandDeep,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandCopper,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: brandDeep, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: brandDeep),
      ),
    );
  }

  ThemeData get darkTheme {
    const Color brandCopper = Color(0xFFCF8D53);
    const Color brandDeep = Color(0xFF111A20);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: brandDeep,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandCopper,
        brightness: Brightness.dark,
      ).copyWith(
        primary: brandCopper,
        secondary: const Color(0xFFE3A46B),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandCopper,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardColor: const Color(0xFF1A252D),
    );
  }
}
