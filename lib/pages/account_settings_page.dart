import 'package:day35/localization/app_language.dart';
import 'package:day35/services/storage_service.dart';
import 'package:day35/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // ── Notification toggles ──────────────────────────────────
  bool _notifBookings    = true;
  bool _notifMessages    = true;
  bool _notifPromotions  = false;
  bool _notifReminders   = true;

  // ── Privacy toggles ──────────────────────────────────────
  bool _profilePublic    = true;
  bool _showLocation     = true;
  bool _showPhone        = false;

  // ── App toggles ──────────────────────────────────────────
  bool _darkMode         = AppThemeController.instance.isDarkMode;
  String _selectedLang   = 'English';

  final List<String> _languages = ['English', 'العربية', 'Français'];

  @override
  Widget build(BuildContext context) {
    final bool isDark  = Theme.of(context).brightness == Brightness.dark;
    final Color primary = Theme.of(context).colorScheme.primary;
    final user = StorageService.instance.getUser();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0C1621) : const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: const Text('Account Settings',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [

          // ── Profile card ───────────────────────────────────
          _ProfileCard(user: user, primary: primary, isDark: isDark),
          const SizedBox(height: 24),

          // ── Account section ────────────────────────────────
          _SectionTitle(label: 'Account', isDark: isDark),
          _SettingsCard(isDark: isDark, children: [
            _NavTile(
              icon: Icons.person_outline_rounded,
              label: 'Edit Profile',
              iconColor: primary,
              isDark: isDark,
              onTap: () => _showEditNameDialog(context, user),
            ),
            _Divider(isDark: isDark),
            _NavTile(
              icon: Icons.lock_outline_rounded,
              label: 'Change Password',
              iconColor: const Color(0xFF3A78C9),
              isDark: isDark,
              onTap: () => _showChangePasswordDialog(context),
            ),
            _Divider(isDark: isDark),
            _NavTile(
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              subtitle: '+216 XX XXX XXX',
              iconColor: const Color(0xFF2EAF7D),
              isDark: isDark,
              onTap: () => _showPhoneDialog(context),
            ),
            _Divider(isDark: isDark),
            _NavTile(
              icon: Icons.email_outlined,
              label: 'Email Address',
              subtitle: user?.email ?? 'Not set',
              iconColor: const Color(0xFFE8A838),
              isDark: isDark,
              onTap: () => _showEmailDialog(context, user),
            ),
          ]),
          const SizedBox(height: 20),

          // ── Notifications ──────────────────────────────────
          _SectionTitle(label: 'Notifications', isDark: isDark),
          _SettingsCard(isDark: isDark, children: [
            _ToggleTile(
              icon: Icons.calendar_today_rounded,
              label: 'Booking Updates',
              iconColor: primary,
              isDark: isDark,
              value: _notifBookings,
              onChanged: (v) => setState(() => _notifBookings = v),
            ),
            _Divider(isDark: isDark),
            _ToggleTile(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'New Messages',
              iconColor: const Color(0xFF3A78C9),
              isDark: isDark,
              value: _notifMessages,
              onChanged: (v) => setState(() => _notifMessages = v),
            ),
            _Divider(isDark: isDark),
            _ToggleTile(
              icon: Icons.local_offer_outlined,
              label: 'Promotions & Offers',
              iconColor: const Color(0xFFD4735E),
              isDark: isDark,
              value: _notifPromotions,
              onChanged: (v) => setState(() => _notifPromotions = v),
            ),
            _Divider(isDark: isDark),
            _ToggleTile(
              icon: Icons.alarm_rounded,
              label: 'Reminders',
              iconColor: const Color(0xFF2EAF7D),
              isDark: isDark,
              value: _notifReminders,
              onChanged: (v) => setState(() => _notifReminders = v),
            ),
          ]),
          const SizedBox(height: 20),

          // ── Privacy ────────────────────────────────────────
          _SectionTitle(label: 'Privacy', isDark: isDark),
          _SettingsCard(isDark: isDark, children: [
            _ToggleTile(
              icon: Icons.public_rounded,
              label: 'Public Profile',
              subtitle: 'Anyone can find your profile',
              iconColor: const Color(0xFF3A8A85),
              isDark: isDark,
              value: _profilePublic,
              onChanged: (v) => setState(() => _profilePublic = v),
            ),
            _Divider(isDark: isDark),
            _ToggleTile(
              icon: Icons.location_on_outlined,
              label: 'Show Location',
              iconColor: const Color(0xFFD4735E),
              isDark: isDark,
              value: _showLocation,
              onChanged: (v) => setState(() => _showLocation = v),
            ),
            _Divider(isDark: isDark),
            _ToggleTile(
              icon: Icons.phone_outlined,
              label: 'Show Phone Number',
              iconColor: const Color(0xFF2EAF7D),
              isDark: isDark,
              value: _showPhone,
              onChanged: (v) => setState(() => _showPhone = v),
            ),
          ]),
          const SizedBox(height: 20),

          // ── Appearance ─────────────────────────────────────
          _SectionTitle(label: 'Appearance', isDark: isDark),
          _SettingsCard(isDark: isDark, children: [
            _ToggleTile(
              icon: Icons.dark_mode_outlined,
              label: 'Dark Mode',
              iconColor: const Color(0xFF6A5ACD),
              isDark: isDark,
              value: _darkMode,
              onChanged: (v) {
                setState(() => _darkMode = v);
                if (AppThemeController.instance.isDarkMode != v) AppThemeController.instance.toggle();
              },
            ),
            _Divider(isDark: isDark),
            _NavTile(
              icon: Icons.language_rounded,
              label: 'Language',
              subtitle: _selectedLang,
              iconColor: const Color(0xFF3A78C9),
              isDark: isDark,
              onTap: () => _showLanguageSheet(context),
            ),
          ]),
          const SizedBox(height: 20),

          // ── Support ────────────────────────────────────────
          _SectionTitle(label: 'Support', isDark: isDark),
          _SettingsCard(isDark: isDark, children: [
            _NavTile(
              icon: Icons.help_outline_rounded,
              label: 'Help Center',
              iconColor: const Color(0xFF3A8A85),
              isDark: isDark,
              onTap: () => _showSnack(context, 'Help Center coming soon'),
            ),
            _Divider(isDark: isDark),
            _NavTile(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              iconColor: const Color(0xFF3A78C9),
              isDark: isDark,
              onTap: () => _showSnack(context, 'Privacy Policy'),
            ),
            _Divider(isDark: isDark),
            _NavTile(
              icon: Icons.description_outlined,
              label: 'Terms of Service',
              iconColor: primary,
              isDark: isDark,
              onTap: () => _showSnack(context, 'Terms of Service'),
            ),
            _Divider(isDark: isDark),
            _NavTile(
              icon: Icons.star_outline_rounded,
              label: 'Rate the App',
              iconColor: const Color(0xFFE8A838),
              isDark: isDark,
              onTap: () => _showSnack(context, 'Thanks for your support! ⭐'),
            ),
          ]),
          const SizedBox(height: 20),

          // ── Danger zone ────────────────────────────────────
          _SectionTitle(label: 'Danger Zone', isDark: isDark),
          _SettingsCard(isDark: isDark, children: [
            _NavTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Account',
              iconColor: const Color(0xFFD94F3D),
              labelColor: const Color(0xFFD94F3D),
              isDark: isDark,
              onTap: () => _showDeleteDialog(context),
            ),
          ]),
          const SizedBox(height: 8),

          // Version
          Center(
            child: Text(
              'AppServicy v1.0.0',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dialogs ────────────────────────────────────────────────

  void _showEditNameDialog(BuildContext context, AppUser? user) {
    final ctrl = TextEditingController(text: user?.name ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Full name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack(context, 'Name updated ✓');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldCtrl, obscureText: true,
                decoration: const InputDecoration(labelText: 'Current password')),
            const SizedBox(height: 10),
            TextField(controller: newCtrl, obscureText: true,
                decoration: const InputDecoration(labelText: 'New password')),
            const SizedBox(height: 10),
            TextField(controller: confirmCtrl, obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm password')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack(context, 'Password updated ✓');
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showPhoneDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Phone Number'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone number',
            prefixText: '+216 ',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack(context, 'Phone number saved ✓');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEmailDialog(BuildContext context, AppUser? user) {
    final ctrl = TextEditingController(text: user?.email ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Email Address'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack(context, 'Email updated ✓');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(999))),
            const Text('Select Language',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ..._languages.map((lang) => ListTile(
              title: Text(lang),
              trailing: _selectedLang == lang
                  ? Icon(Icons.check_circle_rounded, color: primary)
                  : null,
              onTap: () {
                setState(() => _selectedLang = lang);
                if (lang == 'العربية') {
                  AppLanguageController.instance.changeLanguage(AppLanguage.arabic);
                } else if (lang == 'Français') {
                  AppLanguageController.instance.changeLanguage(AppLanguage.french);
                } else {
                  AppLanguageController.instance.changeLanguage(AppLanguage.english);
                }
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account',
            style: TextStyle(color: Color(0xFFD94F3D))),
        content: const Text(
            'This action is permanent and cannot be undone. All your data will be deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD94F3D)),
            onPressed: () {
              Navigator.pop(context);
              _showSnack(context, 'Account deletion requested');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}

// ── Reusable widgets ────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final AppUser? user;
  final Color primary;
  final bool isDark;

  const _ProfileCard({required this.user, required this.primary, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.18), primary.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: primary.withOpacity(0.2),
            backgroundImage: user?.imageUrl != null && user!.imageUrl.isNotEmpty
                ? NetworkImage(user!.imageUrl)
                : null,
            child: user?.imageUrl == null || user!.imageUrl.isEmpty
                ? Icon(Icons.person_rounded, color: primary, size: 30)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Provider',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F1C27),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  user?.email ?? 'No email',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : const Color(0xFF8A9BAB),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    user?.role ?? 'Provider',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: isDark ? Colors.white38 : Colors.black26),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionTitle({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;
  const _SettingsCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF152130) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF243447) : const Color(0xFFEAE0D5),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color iconColor;
  final Color? labelColor;
  final bool isDark;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.iconColor,
    this.labelColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: labelColor ??
                          (isDark ? Colors.white : const Color(0xFF0F1C27)),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : const Color(0xFF8A9BAB),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color iconColor;
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.iconColor,
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF0F1C27),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : const Color(0xFF8A9BAB),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: primary,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 66,
      endIndent: 16,
      color: isDark ? const Color(0xFF243447) : const Color(0xFFEAE0D5),
    );
  }
}
