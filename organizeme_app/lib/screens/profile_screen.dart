import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Profile / Settings screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // User info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'O',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OrganizeMe User',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Free Plan',
                      style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Upgrade card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Go Premium',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock unlimited collections, custom themes, cloud backup, and more.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                  ),
                  child: const Text('Upgrade — \$2.99/mo'),
                ),
              ],
            ),
          ),

          // Settings sections
          _SettingsSection(title: 'Appearance', items: [
            _SettingsItem(icon: Icons.palette_rounded, label: 'Theme', trailing: const Text('Light', style: TextStyle(color: AppColors.onSurfaceVariant))),
            _SettingsItem(icon: Icons.grid_view_rounded, label: 'Icon Pack', trailing: const Text('Default', style: TextStyle(color: AppColors.onSurfaceVariant))),
          ]),

          _SettingsSection(title: 'Data', items: [
            _SettingsItem(icon: Icons.cloud_rounded, label: 'Cloud Backup', trailing: Switch(value: false, onChanged: (_) {})),
            _SettingsItem(icon: Icons.refresh_rounded, label: 'Rescan Apps'),
            _SettingsItem(icon: Icons.delete_sweep_rounded, label: 'Clear Unused Apps'),
          ]),

          _SettingsSection(title: 'Account', items: [
            _SettingsItem(icon: Icons.star_rounded, label: 'Rate the App'),
            _SettingsItem(icon: Icons.share_rounded, label: 'Share OrganizeMe'),
            _SettingsItem(icon: Icons.help_outline_rounded, label: 'Help & Support'),
            _SettingsItem(icon: Icons.description_rounded, label: 'Privacy Policy'),
          ]),

          const SizedBox(height: 24),

          const Center(
            child: Text(
              'OrganizeMe v1.0.0',
              style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;

  const _SettingsItem({required this.icon, required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: AppColors.onSurfaceVariant),
      onTap: () {},
    );
  }
}