import 'package:animate_do/animate_do.dart';
import 'package:day35/pages/start.dart';
import 'package:day35/pages/signup_page.dart';
import 'package:day35/pages/offerer_dashboard.dart';
import 'package:day35/pages/sms_verification_page.dart';
import 'package:day35/localization/app_language.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String? initialRole;
  const LoginPage({super.key, this.initialRole});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late String _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole ?? 'User';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continueToApp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SMSVerificationPage(
          phoneNumber: "+216 5*.***.***8",
          onVerified: () async {
            // Save user to storage
            final user = AppUser(
              id: _selectedRole == 'Provider' ? 'provider_1' : 'user_1',
              name: _selectedRole == 'Provider' ? 'Alex Johnson' : 'Bacem Ben Salah',
              email: _emailController.text.isEmpty ? 'demo@serviny.com' : _emailController.text,
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

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  void _validateAndContinue() {
    final lang = AppLanguageController.instance;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr('invalid_email'))),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr('password_too_short'))),
      );
      return;
    }
    _continueToApp();
  }

  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupPage()),
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
        actions: [
          IconButton(
            onPressed: theme.toggle,
            icon: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              FadeInDown(
                child: Center(
                  child: Image.asset(
                    'logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.lock_person_rounded,
                      size: 80,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  lang.tr('login'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInDown(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  '${lang.tr('access_account_as')} $_selectedRole',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(height: 14),
              Center(
                child: SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(value: 'User', icon: Icon(Icons.person_outline), label: Text('User')),
                    ButtonSegment<String>(value: 'Provider', icon: Icon(Icons.engineering_outlined), label: Text('Provider')),
                  ],
                  selected: <String>{_selectedRole},
                  onSelectionChanged: (Set<String> value) {
                    setState(() => _selectedRole = value.first);
                  },
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: lang.tr('email'),
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: lang.tr('password'),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
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
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: ElevatedButton(
                  onPressed: _validateAndContinue,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  child: Text(
                    lang.tr('login'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 900),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(lang.tr('dont_have_account')),
                    TextButton(
                      onPressed: _goToSignup,
                      child: Text(
                        lang.tr('sign_up'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: TextButton(
                  onPressed: _continueToApp,
                  child: Text(
                    lang.tr('continue_as_guest'),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
