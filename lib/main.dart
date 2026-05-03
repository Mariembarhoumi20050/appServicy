import 'package:day35/pages/onboarding_page.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/start.dart';
import 'package:day35/pages/offerer_dashboard.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
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
        final currentUser = StorageService.instance.getUser();

        Widget home;
        if (currentUser == null) {
          home = const OnboardingPage();
        } else if (currentUser.role == 'Provider') {
          home = const OffererDashboard();
        } else {
          home = const StartPage();
        }

        return Directionality(
          textDirection: lang.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: MaterialApp(
            home: home,
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
