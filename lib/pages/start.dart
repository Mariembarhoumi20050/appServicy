import 'dart:async';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/models/booking.dart';
import 'package:day35/models/service.dart';
import 'package:day35/models/service_provider.dart';
import 'package:day35/pages/chat_list.dart';
import 'package:day35/pages/date_time.dart';
import 'package:day35/pages/select_service.dart';
import 'package:day35/pages/service_subcategory_page.dart';
import 'package:day35/pages/notifications_page.dart';
import 'package:day35/pages/my_bookings_page.dart';
import 'package:day35/pages/user_profile.dart';
import 'package:day35/pages/onboarding_page.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/widgets/app_actions.dart';
import 'package:flutter/material.dart';

// ── Service colours & icons ──────────────────────────────────
class _Svc {
  final String name, url;
  final Color accent;
  final IconData icon;
  const _Svc(this.name, this.url, this.accent, this.icon);
}

const List<_Svc> _kServices = [
  _Svc('Cleaning',         'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/96/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png', Color(0xFF3A8A85), Icons.cleaning_services_rounded),
  _Svc('Plumber',          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/96/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png', Color(0xFF3A78C9), Icons.plumbing_rounded),
  _Svc('Electrician',      'https://img.icons8.com/external-wanicon-flat-wanicon/96/external-multimeter-car-service-wanicon-flat-wanicon.png',                                Color(0xFFE8A838), Icons.bolt_rounded),
  _Svc('Painter',          'https://img.icons8.com/external-itim2101-flat-itim2101/96/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png',                   Color(0xFFD4735E), Icons.format_paint_rounded),
  _Svc('Carpenter',        'https://img.icons8.com/fluency/96/drill.png',                                                                                                    Color(0xFF8D6E63), Icons.handyman_rounded),
  _Svc('Gardener',         'https://img.icons8.com/external-itim2101-flat-itim2101/96/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png',                  Color(0xFF2EAF7D), Icons.yard_rounded),
  _Svc('Tailor',           'https://img.icons8.com/fluency/96/sewing-machine.png',                                                                                           Color(0xFF9C27B0), Icons.checkroom_rounded),
  _Svc('Maid',             'https://img.icons8.com/color/96/housekeeper-female.png',                                                                                         Color(0xFFE91E63), Icons.home_rounded),
  _Svc('Driver',           'https://img.icons8.com/external-sbts2018-lineal-color-sbts2018/96/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png',          Color(0xFF1565C0), Icons.drive_eta_rounded),
  _Svc('AC Repair',        'https://img.icons8.com/color/96/air-conditioner.png',                                                                                            Color(0xFF00BCD4), Icons.ac_unit_rounded),
  _Svc('Pest Control',     'https://img.icons8.com/color/96/bug.png',                                                                                                        Color(0xFF689F38), Icons.pest_control_rounded),
  _Svc('Appliance Repair', 'https://img.icons8.com/color/96/maintenance.png',                                                                                                Color(0xFF546E7A), Icons.build_rounded),
  _Svc('Babysitting',      'https://img.icons8.com/color/96/nanny.png',                                                                                                      Color(0xFFF06292), Icons.child_care_rounded),
];

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _highlighted = 0;
  late Timer _timer;

  // keep legacy Service list for compat with other pages
  final List<Service> services = _kServices
      .map((s) => Service(s.name, s.url))
      .toList();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() => _highlighted = Random().nextInt(_kServices.length));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguageController.instance;
    final Color primary = Theme.of(context).colorScheme.primary;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF0C1621) : const Color(0xFFF8F5F0);
    final Color textPri = isDark ? Colors.white : const Color(0xFF0F1C27);

    return Scaffold(
      backgroundColor: bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Serviny',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: textPri,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationsPage())),
            icon: Icon(Icons.notifications_none_rounded, color: textPri),
          ),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ChatListPage())),
            icon: Icon(Icons.chat_bubble_outline_rounded, color: textPri),
          ),
          AppActions(),
        ],
      ),
      drawer: _buildDrawer(context),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, Color.lerp(primary, Colors.orange, 0.3)!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: MaterialButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SelectService())),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  lang.tr('get_started'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HERO SECTION ──────────────────────────────────
            _HeroCard(
              lang: lang,
              primary: primary,
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // ── LIVE BOOKING ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildLiveBookingCard(lang, primary, isDark),
            ),
            const SizedBox(height: 24),

            // ── SECTION TITLE ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Popular Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F1C27),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SelectService())),
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── SERVICES GRID ─────────────────────────────────
            SizedBox(
              height: 270,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: _kServices.length,
                itemBuilder: (context, index) {
                  final svc = _kServices[index];
                  final isHl = _highlighted == index;
                  final cardBg = isDark
                      ? const Color(0xFF152130)
                      : Colors.white;
                  final border = isDark
                      ? const Color(0xFF243447)
                      : const Color(0xFFEAE0D5);

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceSubCategoryPage(
                          serviceName: svc.name,
                          serviceImage: svc.url,
                        ),
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        color: isHl
                            ? svc.accent.withOpacity(isDark ? 0.18 : 0.10)
                            : cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isHl ? svc.accent : border,
                          width: isHl ? 1.8 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isHl
                                ? svc.accent.withOpacity(0.20)
                                : Colors.black.withOpacity(isDark ? 0.15 : 0.05),
                            blurRadius: isHl ? 14 : 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: svc.accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: Image.network(
                                svc.url,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                  svc.icon,
                                  color: svc.accent,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lang.trService(svc.name),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isHl
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isHl
                                  ? svc.accent
                                  : isDark
                                      ? Colors.white.withOpacity(0.85)
                                      : const Color(0xFF0F1C27),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Live Booking Card ───────────────────────────────────────
  Widget _buildLiveBookingCard(
      AppLanguageController lang, Color primary, bool isDark) {
    final Booking? pending = _latestPendingBooking;
    final Booking? last = _latestBooking;
    final cardBg = isDark ? const Color(0xFF152130) : Colors.white;
    final border = isDark ? const Color(0xFF243447) : const Color(0xFFEAE0D5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.local_shipping_outlined,
                    color: primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                lang.tr('live_booking_status'),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF0F1C27),
                ),
              ),
              const Spacer(),
              if (pending != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2EAF7D).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2EAF7D),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (pending != null) ...[
            Text(
              '${pending.serviceName} · ${pending.providerName}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF0F1C27),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${lang.tr('status_pending')} · ${pending.date} ${pending.time}',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? Colors.white54
                    : const Color(0xFF8A9BAB),
              ),
            ),
            if ((pending.arrivalCode ?? '').isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${lang.tr('arrival_code')}: ${pending.arrivalCode}',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ] else
            Text(
              lang.tr('no_active_booking'),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white38 : const Color(0xFF8A9BAB),
              ),
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const MyBookingsPage())),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(lang.tr('view_my_bookings'),
                      style: const TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: last == null ? null : () => _quickRebook(last),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(lang.tr('quick_rebook'),
                      style: const TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Booking? get _latestBooking {
    final b = BookingStore.instance.all;
    return b.isEmpty ? null : b.last;
  }

  Booking? get _latestPendingBooking {
    final b = BookingStore.instance.all;
    for (int i = b.length - 1; i >= 0; i--) {
      if (b[i].status == BookingStatus.pending) return b[i];
    }
    return null;
  }

  void _quickRebook(Booking last) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DateAndTime(
          serviceName: last.serviceName,
          providerName: last.providerName,
          providerCity: 'Nearby',
          providerImageUrl: last.providerImageUrl,
          basePriceTnd: last.price,
          availabilitySlots: const ['Today 17:30', 'Tomorrow 09:00'],
          extras: const [
            ServiceExtra(
              name: 'Fast response',
              imageUrl: 'https://img.icons8.com/color/96/clock.png',
              priceTnd: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor:
          isDark ? const Color(0xFF0C1621) : const Color(0xFFF8F5F0),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, Color.lerp(primary, Colors.orange, 0.3)!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://uifaces.co/our-content/donated/NY9hnAbp.jpg'),
              ),
            ),
            accountName: const Text('Bacem Ben Salah',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            accountEmail: const Text('bacem@email.com'),
          ),
          _drawerItem(context, Icons.person_outline_rounded, 'My Profile',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UserProfilePage()))),
          _drawerItem(context, Icons.history_rounded, 'My Bookings',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MyBookingsPage()))),
          _drawerItem(context, Icons.grid_view_rounded, 'All Services',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => SelectService()))),
          Divider(
              color: isDark
                  ? const Color(0xFF243447)
                  : const Color(0xFFEAE0D5)),
          _drawerItem(context, Icons.help_outline_rounded, 'Support', () {}),
          const Spacer(),
          _drawerItem(
            context,
            Icons.logout_rounded,
            'Logout',
            () async {
              await StorageService.instance.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingPage()),
                  (r) => false);
            },
            color: const Color(0xFFD94F3D),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ??
        (isDark ? Colors.white.withOpacity(0.85) : const Color(0xFF0F1C27));
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(label,
          style: TextStyle(
              color: c, fontWeight: FontWeight.w500, fontSize: 15)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

// ── Hero Card widget ────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  final AppLanguageController lang;
  final Color primary;
  final bool isDark;

  const _HeroCard(
      {required this.lang, required this.primary, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 100, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  primary.withOpacity(0.28),
                  primary.withOpacity(0.10),
                ]
              : [
                  primary.withOpacity(0.16),
                  primary.withOpacity(0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primary.withOpacity(0.20),
        ),
      ),
      child: Column(
        children: [
          // Logo — transparent, pas de fond blanc
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              'logo.png',
              height: 72,
              fit: BoxFit.contain,
              // colorBlendMode + color pour supprimer le fond blanc si l'image
              // est un PNG avec fond blanc — on laisse Flutter gérer nativement
              errorBuilder: (_, __, ___) => Icon(
                Icons.home_repair_service_rounded,
                size: 60,
                color: primary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Text(
              lang.tr('home_hero'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F1C27),
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 500),
            child: Text(
              lang.tr('home_desc'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: isDark
                    ? Colors.white.withOpacity(0.55)
                    : const Color(0xFF8A9BAB),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Stats row
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(value: '500+', label: 'Providers', primary: primary),
                _StatDivider(isDark: isDark),
                _Stat(value: '14', label: 'Services', primary: primary),
                _StatDivider(isDark: isDark),
                _Stat(value: '4.8★', label: 'Rating', primary: primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  final Color primary;
  const _Stat({required this.value, required this.label, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: primary)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8A9BAB),
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  final bool isDark;
  const _StatDivider({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1,
        height: 28,
        color: isDark
            ? Colors.white.withOpacity(0.12)
            : Colors.black.withOpacity(0.10));
  }
}