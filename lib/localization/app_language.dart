import 'package:flutter/material.dart';

enum AppLanguage { english, french, arabic }

class AppLanguageController extends ChangeNotifier {
  static final AppLanguageController instance = AppLanguageController._();

  AppLanguageController._();

  AppLanguage _current = AppLanguage.english;

  AppLanguage get current => _current;

  bool get isArabic => _current == AppLanguage.arabic;

  void changeLanguage(AppLanguage language) {
    if (_current == language) return;
    _current = language;
    notifyListeners();
  }

  String tr(String key) {
    return _translations[_current]?[key] ?? _translations[AppLanguage.english]![key] ?? key;
  }

  String trService(String serviceName) {
    final String key =
        'service_${serviceName.toLowerCase().replaceAll(' ', '_')}';
    return tr(key);
  }

  static const Map<AppLanguage, Map<String, String>> _translations = {
    AppLanguage.english: {
      'app_name': 'serviny',
      'open_chat': 'Open Chat',
      'get_started': 'Get Started',
      'home_hero': 'Easy, reliable way to take \ncare of your home',
      'home_desc': 'We provide you with the best people to help take care of your home.',
      'which_service': 'Which service \ndo you need?',
      'choose_offerer': 'Choose your offerer',
      'chat': 'Chat',
      'book': 'Book',
      'select_date': 'Select Date & Time',
      'provider': 'Provider',
      'base_price': 'Base Price',
      'total': 'Total',
      'additional_service': 'Additional Service',
      'repeat': 'Repeat',
      'language': 'Language',
      'french': 'French',
      'arabic': 'Arabic',
      'english': 'English',
      'service_cleaning': 'Cleaning',
      'service_plumber': 'Plumber',
      'service_electrician': 'Electrician',
      'service_painter': 'Painter',
      'service_carpenter': 'Carpenter',
      'service_gardener': 'Gardener',
      'service_tailor': 'Tailor',
      'service_maid': 'Maid',
      'service_driver': 'Driver',
      'service_cook': 'Cook',
      'service_ac_repair': 'AC Repair',
      'service_pest_control': 'Pest Control',
      'service_appliance_repair': 'Appliance Repair',
      'service_babysitting': 'Babysitting',
    },
    AppLanguage.french: {
      'app_name': 'serviny',
      'open_chat': 'Ouvrir le chat',
      'get_started': 'Commencer',
      'home_hero': 'Une facon simple et fiable de \nprendre soin de votre maison',
      'home_desc': 'Nous vous proposons les meilleurs prestataires pour votre maison.',
      'which_service': 'Quel service \naviez-vous besoin ?',
      'choose_offerer': 'Choisissez le prestataire',
      'chat': 'Discuter',
      'book': 'Reserver',
      'select_date': 'Choisir la date et l\'heure',
      'provider': 'Prestataire',
      'base_price': 'Prix de base',
      'total': 'Total',
      'additional_service': 'Service supplementaire',
      'repeat': 'Repetition',
      'language': 'Langue',
      'french': 'Francais',
      'arabic': 'Arabe',
      'english': 'Anglais',
      'service_cleaning': 'Nettoyage',
      'service_plumber': 'Plombier',
      'service_electrician': 'Electricien',
      'service_painter': 'Peintre',
      'service_carpenter': 'Menuisier',
      'service_gardener': 'Jardinier',
      'service_tailor': 'Couturier',
      'service_maid': 'Femme de menage',
      'service_driver': 'Chauffeur',
      'service_cook': 'Cuisinier',
      'service_ac_repair': 'Reparation climatiseur',
      'service_pest_control': 'Lutte antiparasitaire',
      'service_appliance_repair': 'Reparation electromenager',
      'service_babysitting': 'Garde d enfants',
    },
    AppLanguage.arabic: {
      'app_name': 'سيرفيني',
      'open_chat': 'افتح الدردشة',
      'get_started': 'ابدأ',
      'home_hero': 'طريقة سهلة وموثوقة \nللعناية بمنزلك',
      'home_desc': 'نوفر لك افضل مقدمي الخدمات للعناية بالمنزل.',
      'which_service': 'ما هي الخدمة \nالتي تحتاجها؟',
      'choose_offerer': 'اختر مقدم الخدمة',
      'chat': 'دردشة',
      'book': 'احجز',
      'select_date': 'اختر التاريخ والوقت',
      'provider': 'مقدم الخدمة',
      'base_price': 'السعر الاساسي',
      'total': 'المجموع',
      'additional_service': 'خدمات اضافية',
      'repeat': 'التكرار',
      'language': 'اللغة',
      'french': 'الفرنسية',
      'arabic': 'العربية',
      'english': 'الانجليزية',
      'service_cleaning': 'تنظيف',
      'service_plumber': 'سباك',
      'service_electrician': 'كهربائي',
      'service_painter': 'دهان',
      'service_carpenter': 'نجار',
      'service_gardener': 'بستاني',
      'service_tailor': 'خياط',
      'service_maid': 'عاملة منزل',
      'service_driver': 'سائق',
      'service_cook': 'طباخ',
      'service_ac_repair': 'اصلاح المكيف',
      'service_pest_control': 'مكافحة الحشرات',
      'service_appliance_repair': 'اصلاح الاجهزة',
      'service_babysitting': 'مجالسة اطفال',
    },
  };
}
