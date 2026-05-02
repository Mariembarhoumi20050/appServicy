import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/onboarding_page.dart';
import 'package:day35/pages/offerer_dashboard.dart';
import 'package:day35/pages/start.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppActions extends StatelessWidget {
  final List<Widget>? additionalActions;

  const AppActions({super.key, this.additionalActions});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeController.instance;
    final lang = AppLanguageController.instance;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (additionalActions != null) ...additionalActions!,
        IconButton(
          onPressed: () => _goHome(context),
          icon: const Icon(Icons.home_rounded),
          tooltip: 'Home',
        ),
        // Theme Toggle
        IconButton(
          onPressed: theme.toggle,
          icon: Icon(theme.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
          tooltip: 'Toggle Theme',
        ),
        // Language Toggle
        PopupMenuButton<AppLanguage>(
          icon: const Icon(Icons.language_rounded),
          tooltip: lang.tr('language'),
          onSelected: (AppLanguage newLang) {
            lang.changeLanguage(newLang);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<AppLanguage>>[
            _buildLangItem(AppLanguage.english, '🇺🇸', lang.tr('english')),
            _buildLangItem(AppLanguage.french, '🇫🇷', lang.tr('french')),
            _buildLangItem(AppLanguage.arabic, '🇹🇳', lang.tr('arabic')),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  PopupMenuItem<AppLanguage> _buildLangItem(AppLanguage value, String flag, String label) {
    return PopupMenuItem<AppLanguage>(
      value: value,
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  void _goHome(BuildContext context) {
    final AppUser? currentUser = StorageService.instance.getUser();
    Widget target;
    if (currentUser == null) {
      target = const OnboardingPage();
    } else if (currentUser.role == 'Provider') {
      target = const OffererDashboard();
    } else {
      target = const StartPage();
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => target),
      (Route<dynamic> route) => false,
    );
  }
}
