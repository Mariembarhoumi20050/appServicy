import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/service.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/service_subcategory_page.dart';
import 'package:day35/features/voice/voice_screen.dart';
import 'package:day35/widgets/theme_toggle_action.dart';
import 'package:flutter/material.dart';

// Catégories avec couleur d'accent + icône de fallback
class _ServiceDef {
  final String name;
  final String imageUrl;
  final Color accent;
  final IconData fallbackIcon;
  const _ServiceDef(this.name, this.imageUrl, this.accent, this.fallbackIcon);
}

class SelectService extends StatefulWidget {
  const SelectService({Key? key}) : super(key: key);
  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  final List<_ServiceDef> _services = const [
    _ServiceDef('Cleaning',         'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/96/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
        Color(0xFF3A8A85), Icons.cleaning_services_rounded),
    _ServiceDef('Plumber',          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/96/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
        Color(0xFF3A78C9), Icons.plumbing_rounded),
    _ServiceDef('Electrician',      'https://img.icons8.com/external-wanicon-flat-wanicon/96/external-multimeter-car-service-wanicon-flat-wanicon.png',
        Color(0xFFE8A838), Icons.bolt_rounded),
    _ServiceDef('Painter',          'https://img.icons8.com/external-itim2101-flat-itim2101/96/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png',
        Color(0xFFD4735E), Icons.format_paint_rounded),
    _ServiceDef('Carpenter',        'https://img.icons8.com/fluency/96/drill.png',
        Color(0xFF8D6E63), Icons.handyman_rounded),
    _ServiceDef('Gardener',         'https://img.icons8.com/external-itim2101-flat-itim2101/96/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png',
        Color(0xFF2EAF7D), Icons.yard_rounded),
    _ServiceDef('Tailor',           'https://img.icons8.com/fluency/96/sewing-machine.png',
        Color(0xFF9C27B0), Icons.checkroom_rounded),
    _ServiceDef('Maid',             'https://img.icons8.com/color/96/housekeeper-female.png',
        Color(0xFFE91E63), Icons.home_rounded),
    _ServiceDef('Driver',           'https://img.icons8.com/external-sbts2018-lineal-color-sbts2018/96/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png',
        Color(0xFF1565C0), Icons.drive_eta_rounded),
    _ServiceDef('Cook',             'https://img.icons8.com/external-wanicon-flat-wanicon/96/external-cooking-daily-routine-wanicon-flat-wanicon.png',
        Color(0xFFFF7043), Icons.restaurant_rounded),
    _ServiceDef('AC Repair',        'https://img.icons8.com/color/96/air-conditioner.png',
        Color(0xFF00BCD4), Icons.ac_unit_rounded),
    _ServiceDef('Pest Control',     'https://img.icons8.com/color/96/bug.png',
        Color(0xFF689F38), Icons.pest_control_rounded),
    _ServiceDef('Appliance Repair', 'https://img.icons8.com/color/96/maintenance.png',
        Color(0xFF546E7A), Icons.build_rounded),
    _ServiceDef('Babysitting',      'https://img.icons8.com/color/96/nanny.png',
        Color(0xFFF06292), Icons.child_care_rounded),
  ];

  int _selected = -1;
  String _search = '';

  List<_ServiceDef> get _filtered => _search.isEmpty
      ? _services
      : _services.where((s) =>
          s.name.toLowerCase().contains(_search.toLowerCase())).toList();

  // Group into rows of 2 for the horizontal scroll
  List<List<_ServiceDef>> get _rows {
    final list = _filtered;
    final rows = <List<_ServiceDef>>[];
    for (int i = 0; i < list.length; i += 2) {
      rows.add(i + 1 < list.length ? [list[i], list[i + 1]] : [list[i]]);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg      = isDark ? const Color(0xFF0C1621) : const Color(0xFFF8F5F0);
    final Color cardBg  = isDark ? const Color(0xFF152130) : Colors.white;
    final Color border  = isDark ? const Color(0xFF243447) : const Color(0xFFEAE0D5);
    final Color textPri = isDark ? Colors.white : const Color(0xFF0F1C27);
    final Color textSec = isDark ? const Color(0xFF8A9BAB) : const Color(0xFF8A9BAB);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          const ThemeToggleAction(),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ChatListPage())),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'voice',
            backgroundColor: primary,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => VoiceScreen(
                  services: _services.map((s) => s.name).toList(),
                ))),
            child: const Icon(Icons.mic_rounded),
          ),
          if (_selected >= 0) ...[
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'next',
              backgroundColor: primary,
              onPressed: () {
                final s = _services[_selected];
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ServiceSubCategoryPage(
                    serviceName: s.name,
                    serviceImage: s.imageUrl,
                  ),
                ));
              },
              child: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
            ),
          ],
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.tr('which_service'),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textPri,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Scroll horizontally to browse all services',
                    style: TextStyle(fontSize: 13, color: textSec),
                  ),
                  const SizedBox(height: 14),

                  // Search bar
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border),
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      style: TextStyle(fontSize: 14, color: textPri),
                      decoration: InputDecoration(
                        hintText: 'Search a service...',
                        hintStyle: TextStyle(color: textSec, fontSize: 14),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: textSec, size: 20),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Horizontal scroll grid ───────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text('No service found',
                        style: TextStyle(color: textSec)),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_rows.length, (colIdx) {
                        final col = _rows[colIdx];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: col.map((svc) {
                              final globalIdx = _services.indexOf(svc);
                              final isSelected = _selected == globalIdx;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: FadeInRight(
                                  delay: Duration(milliseconds: 60 * colIdx),
                                  duration: const Duration(milliseconds: 350),
                                  child: _ServiceCard(
                                    svc: svc,
                                    isSelected: isSelected,
                                    isDark: isDark,
                                    cardBg: cardBg,
                                    border: border,
                                    textPri: textPri,
                                    textSec: textSec,
                                    label: lang.trService(svc.name),
                                    onTap: () => setState(() =>
                                        _selected = isSelected ? -1 : globalIdx),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final _ServiceDef svc;
  final bool isSelected;
  final bool isDark;
  final Color cardBg;
  final Color border;
  final Color textPri;
  final Color textSec;
  final String label;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.svc,
    required this.isSelected,
    required this.isDark,
    required this.cardBg,
    required this.border,
    required this.textPri,
    required this.textSec,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 130,
        height: 150,
        decoration: BoxDecoration(
          color: isSelected
              ? svc.accent.withOpacity(isDark ? 0.18 : 0.10)
              : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? svc.accent : border,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: svc.accent.withOpacity(0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.18 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon bubble
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: svc.accent.withOpacity(isSelected ? 0.20 : 0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  svc.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    svc.fallbackIcon,
                    color: svc.accent,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? svc.accent : textPri,
                  height: 1.3,
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 6),
              Container(
                width: 24,
                height: 4,
                decoration: BoxDecoration(
                  color: svc.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}