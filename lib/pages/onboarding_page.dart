import 'package:animate_do/animate_do.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/pages/login_page.dart';
import 'package:day35/widgets/app_actions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _rotateCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLanguageController.instance,
      builder: (context, _) {
        final lang = AppLanguageController.instance;
        final Color primary = Theme.of(context).colorScheme.primary;
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        final Color bg = isDark ? const Color(0xFF0C1621) : const Color(0xFFF8F5F0);
        final Color textPri = isDark ? Colors.white : const Color(0xFF0F1C27);
        final Color textSec = isDark
            ? Colors.white.withOpacity(0.50)
            : const Color(0xFF8A9BAB);
        const Color goldLight = Color(0xFFD4A85C);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: const [AppActions()],
          ),
          body: Stack(
            children: [
              // ── Decorative bg circles ──────────────────────
              Positioned(
                top: -80, right: -80,
                child: AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (_, child) => Transform.rotate(
                    angle: _rotateCtrl.value * 2 * math.pi,
                    child: child,
                  ),
                  child: Container(
                    width: 280, height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(colors: [
                        primary.withOpacity(0.10),
                        primary.withOpacity(0.02),
                        primary.withOpacity(0.10),
                      ]),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 130, left: -60,
                child: Container(
                  width: 200, height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: goldLight.withOpacity(0.07),
                  ),
                ),
              ),
              Positioned(
                top: 220, left: -20,
                child: Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withOpacity(0.08),
                  ),
                ),
              ),

              // ── Content ────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // Logo — transparent background via circular glow rings
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: AnimatedBuilder(
                          animation: _pulse,
                          builder: (_, child) => Transform.scale(
                            scale: _pulse.value, child: child),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer glow
                              Container(
                                width: 170, height: 170,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(colors: [
                                    primary.withOpacity(0.18),
                                    primary.withOpacity(0.0),
                                  ]),
                                ),
                              ),
                              // Inner ring
                              Container(
                                width: 124, height: 124,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      primary.withOpacity(0.15),
                                      goldLight.withOpacity(0.10),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: primary.withOpacity(0.22),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              // Logo — no white background
                              SizedBox(
                                width: 82, height: 82,
                                child: Image.asset(
                                  'logo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.home_repair_service_rounded,
                                    size: 64, color: primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // App name with gold gradient
                      FadeInDown(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 600),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [primary, goldLight],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: Text(
                            lang.tr('app_name'),
                            style: const TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tagline
                      FadeInDown(
                        delay: const Duration(milliseconds: 350),
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          lang.tr('home_desc'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15, height: 1.6, color: textSec,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Feature pills
                      FadeInUp(
                        delay: const Duration(milliseconds: 450),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Pill(icon: Icons.verified_rounded,
                                label: 'Verified', primary: primary),
                            const SizedBox(width: 8),
                            _Pill(icon: Icons.bolt_rounded,
                                label: 'Fast', primary: primary),
                            const SizedBox(width: 8),
                            _Pill(icon: Icons.star_rounded,
                                label: '4.8★', primary: primary),
                          ],
                        ),
                      ),

                      const Spacer(flex: 3),

                      // Primary CTA
                      FadeInUp(
                        delay: const Duration(milliseconds: 550),
                        duration: const Duration(milliseconds: 500),
                        child: _GradientButton(
                          label: lang.tr('i_need_service'),
                          primary: primary,
                          onTap: () => _go(context, 'User'),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Secondary CTA
                      FadeInUp(
                        delay: const Duration(milliseconds: 680),
                        duration: const Duration(milliseconds: 500),
                        child: _OutlineButton(
                          label: lang.tr('i_am_provider'),
                          primary: primary,
                          textPri: textPri,
                          onTap: () => _go(context, 'Provider'),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Footer
                      FadeInUp(
                        delay: const Duration(milliseconds: 750),
                        child: Text(
                          'By continuing you agree to our Terms & Privacy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: textSec.withOpacity(0.55),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _go(BuildContext context, String role) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => LoginPage(initialRole: role),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }
}

// ── Widgets ─────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primary;
  const _Pill({required this.icon, required this.label, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: primary),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primary)),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final Color primary;
  final VoidCallback onTap;
  const _GradientButton(
      {required this.label, required this.primary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD4A85C);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, Color.lerp(primary, gold, 0.35)!],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.38),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3)),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final Color primary;
  final Color textPri;
  final VoidCallback onTap;
  const _OutlineButton(
      {required this.label,
      required this.primary,
      required this.textPri,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: primary, width: 1.8),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: textPri,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3)),
        ),
      ),
    );
  }
}