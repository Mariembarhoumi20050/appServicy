import 'package:animate_do/animate_do.dart';
import 'package:day35/pages/start.dart';
import 'package:day35/pages/offerer_dashboard.dart';
import 'package:day35/pages/sms_verification_page.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedRole = 'User';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continueToApp() {
    final lang = AppLanguageController.instance;
    if (_nameController.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr('invalid_name'))),
      );
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr('invalid_email'))),
      );
      return;
    }
    if (_passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr('password_too_short'))),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SMSVerificationPage(
          phoneNumber: _phoneController.text.isEmpty ? "+216 5*.***.***8" : _phoneController.text,
          onVerified: () async {
            final user = AppUser(
              id: _selectedRole == 'Provider' ? 'provider_1' : 'user_1',
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              role: _selectedRole,
              imageUrl: _selectedRole == 'Provider'
                  ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1974&auto=format&fit=crop'
                  : 'https://uifaces.co/our-content/donated/NY9hnAbp.jpg',
            );
            await StorageService.instance.saveUser(user);
            if (!mounted) return;
            if (_selectedRole == 'Provider') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OffererDashboard()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const StartPage()),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeController.instance;
    final lang = AppLanguageController.instance;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: theme.toggle,
            icon: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: CompetitionTokens.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: CompetitionTokens.heroGradient(colorScheme.primary),
                  borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
                  boxShadow: CompetitionTokens.softShadow(colorScheme.primary),
                ),
                child: const Text(
                  'Safe, fast, and trusted service onboarding',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),
              FadeInDown(
                child: Center(
                  child: Image.asset(
                    'logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 60,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  lang.tr('create_account'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleToggle('User', Icons.person_outline),
                    const SizedBox(width: 20),
                    _buildRoleToggle('Provider', Icons.engineering_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildField(
                controller: _nameController,
                label: lang.tr('full_name'),
                icon: Icons.person_outline_rounded,
                delay: 500,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _emailController,
                label: lang.tr('email'),
                icon: Icons.email_outlined,
                delay: 600,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _phoneController,
                label: lang.tr('phone_number'),
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
                delay: 700,
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: lang.tr('password'),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 900),
                child: ElevatedButton(
                  onPressed: _continueToApp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
                    ),
                    elevation: 5,
                    shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  child: Text(
                    lang.tr('sign_up'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(lang.tr('already_have_account')),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        lang.tr('login'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int delay,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleToggle(String role, IconData icon) {
    final isSelected = _selectedRole == role;
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected ? colorScheme.primary : Colors.grey;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(CompetitionTokens.radiusMd),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              role,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
