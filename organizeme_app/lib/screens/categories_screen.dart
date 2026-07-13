import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final categories = provider.categories;
          final counts = provider.categoryCounts;

          if (categories.isEmpty) {
            return const Center(
              child: Text('No apps found. Scan your apps first!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final count = counts[category] ?? 0;
              final icon = _getCategoryIcon(category);
              return _buildCategoryCard(
                context, category, icon, count, theme);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String category, IconData icon, int count, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 28),
        ),
        title: Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count app${count != 1 ? 's' : ''}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailScreen(category: category),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Social': return Icons.people_rounded;
      case 'Finance': return Icons.account_balance_rounded;
      case 'Games': return Icons.sports_esports_rounded;
      case 'Music': return Icons.music_note_rounded;
      case 'Photos': return Icons.photo_camera_rounded;
      case 'Health': return Icons.favorite_rounded;
      case 'Travel': return Icons.flight_rounded;
      case 'Shopping': return Icons.shopping_cart_rounded;
      case 'Education': return Icons.school_rounded;
      case 'Utilities': return Icons.build_rounded;
      case 'Home': return Icons.home_rounded;
      case 'Work': return Icons.work_rounded;
      default: return Icons.apps_rounded;
    }
  }
}