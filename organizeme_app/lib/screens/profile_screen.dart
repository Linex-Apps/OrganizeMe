import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Stats card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.apps_rounded,
                            size: 40, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'OrganizeMe',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            '${provider.appCount}',
                            'Total Apps',
                            Icons.apps_rounded,
                            theme,
                          ),
                          Container(
                            height: 40, width: 1,
                            color: Colors.grey.shade200,
                          ),
                          _buildStatItem(
                            '${provider.categories.length}',
                            'Categories',
                            Icons.folder_rounded,
                            theme,
                          ),
                          Container(
                            height: 40, width: 1,
                            color: Colors.grey.shade200,
                          ),
                          _buildStatItem(
                            '${provider.favorites.length}',
                            'Favorites',
                            Icons.star_rounded,
                            theme,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Premium upgrade card
              _buildPremiumCard(context, provider),
              const SizedBox(height: 16),

              // Usage stats
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Usage Stats',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    _buildUsageStat(
                      Icons.history_rounded,
                      'Recently Used',
                      '${provider.recentApps.length} apps',
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildUsageStat(
                      Icons.trending_up_rounded,
                      'Most Used',
                      provider.frequentlyUsed.isNotEmpty
                          ? '${provider.frequentlyUsed.first.name} (${provider.frequentlyUsed.first.usageCount}x)'
                          : 'N/A',
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildUsageStat(
                      Icons.delete_sweep_rounded,
                      'Unused (30+ days)',
                      '${provider.getUnusedApps(days: 30).length} apps',
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildUsageStat(
                      Icons.delete_forever_rounded,
                      'Unused (90+ days)',
                      '${provider.getUnusedApps(days: 90).length} apps',
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildUsageStat(
                      Icons.delete_outline_rounded,
                      'Unused (180+ days)',
                      '${provider.getUnusedApps(days: 180).length} apps',
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rescan button
              OutlinedButton.icon(
                onPressed: () => provider.scanApps(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Rescan Apps'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // App info
              Center(
                child: Column(
                  children: [
                    Text(
                      'OrganizeMe v1.0.0',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your phone. Finally organized.',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, AppProvider provider) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEAB308).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.stars_rounded,
                  color: Color(0xFFEAB308), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OrganizeMe Premium',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${provider.collectionCount}/3 collections • '
                    '${provider.appCount} apps organized',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPremiumFeature('Unlimited collections'),
                      const SizedBox(width: 12),
                      _buildPremiumFeature('Cloud backup'),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _showPremiumUpsell(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAB308),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text('Upgrade',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFeature(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, color: Color(0xFF22C55E), size: 14),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }

  void _showPremiumUpsell(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAB308).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.stars_rounded,
                    size: 36, color: Color(0xFFEAB308)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Upgrade to Premium',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock the full OrganizeMe experience',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 24),
              const _PremiumFeatureRow(
                icon: Icons.folder_rounded,
                text: 'Unlimited collections',
                desc: 'Organize without limits',
              ),
              const _PremiumFeatureRow(
                icon: Icons.palette_rounded,
                text: 'Custom icons & themes',
                desc: 'Make it truly yours',
              ),
              const _PremiumFeatureRow(
                icon: Icons.cloud_rounded,
                text: 'Cloud backup & sync',
                desc: 'Never lose your setup',
              ),
              const _PremiumFeatureRow(
                icon: Icons.analytics_rounded,
                text: 'Advanced usage stats',
                desc: 'Deep insights into habits',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAB308),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    '\$2.99/month • \$19.99/year',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Maybe later'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildUsageStat(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumFeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String desc;
  const _PremiumFeatureRow({
    required this.icon,
    required this.text,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
        ],
      ),
    );
  }
}