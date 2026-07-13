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
                      const Icon(Icons.apps_rounded,
                          size: 48, color: Color(0xFF2563EB)),
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
                          ),
                          _buildStatItem(
                            '${provider.categories.length}',
                            'Categories',
                            Icons.folder_rounded,
                          ),
                          _buildStatItem(
                            '${provider.favorites.length}',
                            'Favorites',
                            Icons.star_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Plan info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAB308).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.stars_rounded,
                            color: Color(0xFFEAB308), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Free Plan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${provider.collectionCount}/3 collections used',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Show premium upsell
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAB308),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Upgrade'),
                      ),
                    ],
                  ),
                ),
              ),
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
                    if (provider.recentApps.isNotEmpty) ...[
                      _buildUsageStat(
                        Icons.history_rounded,
                        'Recently Used',
                        '${provider.recentApps.length} apps',
                      ),
                    ],
                    if (provider.frequentlyUsed.isNotEmpty) ...[
                      _buildUsageStat(
                        Icons.trending_up_rounded,
                        'Most Used',
                        '${provider.frequentlyUsed.first.name} (${provider.frequentlyUsed.first.usageCount} times)',
                      ),
                    ],
                    _buildUsageStat(
                      Icons.delete_sweep_rounded,
                      'Unused (30+ days)',
                      '${provider.getUnusedApps(days: 30).length} apps',
                    ),
                    _buildUsageStat(
                      Icons.delete_forever_rounded,
                      'Unused (90+ days)',
                      '${provider.getUnusedApps(days: 90).length} apps',
                    ),
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
              ElevatedButton.icon(
                onPressed: () => provider.scanApps(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Rescan Apps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
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

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2563EB), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildUsageStat(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}