import 'package:day35/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ThemeToggleAction extends StatelessWidget {
  const ThemeToggleAction({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeController theme = AppThemeController.instance;
    return IconButton(
      tooltip: theme.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: theme.toggle,
      icon: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
    );
  }
}
