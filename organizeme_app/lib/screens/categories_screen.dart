import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Categories list screen — shows all app categories.
class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData('Social', Icons.people_rounded, AppColors.primary, 12),
      _CategoryData('Work', Icons.work_rounded, AppColors.accent, 8),
      _CategoryData('Entertainment', Icons.movie_rounded, AppColors.success, 15),
      _CategoryData('Finance', Icons.account_balance_rounded, AppColors.error, 4),
      _CategoryData('Health', Icons.favorite_rounded, const Color(0xFFEC4899), 5),
      _CategoryData('Travel', Icons.flight_rounded, const Color(0xFF8B5CF6), 6),
      _CategoryData('Shopping', Icons.shopping_bag_rounded, const Color(0xFFF97316), 7),
      _CategoryData('Education', Icons.school_rounded, const Color(0xFF14B8A6), 3),
      _CategoryData('Utilities', Icons.build_rounded, const Color(0xFF6B7280), 9),
      _CategoryData('Photography', Icons.camera_alt_rounded, const Color(0xFF1C1917), 2),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 76, endIndent: 16),
        itemBuilder: (_, i) {
          final cat = categories[i];
          return ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(cat.icon, color: cat.color, size: 24),
            ),
            title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${cat.count} apps'),
            trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryDetailScreen(category: cat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Category detail screen — shows apps within a category.
class CategoryDetailScreen extends StatelessWidget {
  final _CategoryData category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(category.icon, size: 40, color: category.color),
            ),
            const SizedBox(height: 16),
            Text(
              '${category.count} apps in ${category.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap "Scan Apps" to detect and populate this category.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Scan Apps'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  final String name;
  final IconData icon;
  final Color color;
  final int count;

  const _CategoryData(this.name, this.icon, this.color, this.count);
}