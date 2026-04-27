import 'package:day35/pages/home.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/login_page.dart';
import 'package:day35/pages/select_service.dart';
import 'package:day35/pages/start.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main () {
  runApp(const ServinyApp());
}

class ServinyApp extends StatelessWidget {
  const ServinyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(
        <Listenable>[
          AppLanguageController.instance,
          AppThemeController.instance,
        ],
      ),
      builder: (BuildContext context, _) {
        final AppLanguageController lang = AppLanguageController.instance;
        final AppThemeController theme = AppThemeController.instance;
        return Directionality(
          textDirection: lang.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: MaterialApp(
            home: const LoginPage(),
            debugShowCheckedModeBanner: false,
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          ),
        );
      },
    );
  }
}
