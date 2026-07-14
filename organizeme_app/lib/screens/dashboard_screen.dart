import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_info.dart';
import 'categories_screen.dart';
import 'collections_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'category_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const Text(
              'OrganizeMe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (!provider.hasScanned) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apps_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Scan your apps to get started',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => provider.scanApps(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Favorites section
                if (provider.favorites.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '⭐ Favorites (${provider.favorites.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _FavoritesView(),
                          ),
                        ),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildHorizontalAppList(context, provider.favorites.take(8).toList()),
                  const SizedBox(height: 24),
                ],

                // Recent apps section
                if (provider.recentApps.isNotEmpty) ...[
                  _buildSectionHeader(context, '🕐 Recently Used', () {}),
                  const SizedBox(height: 8),
                  _buildHorizontalAppList(context, provider.recentApps.take(8).toList()),
                  const SizedBox(height: 24),
                ],

                // Categories section
                _buildSectionHeader(
                  context,
                  '📁 Categories',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                  ),
                ),
                const SizedBox(height: 8),
                _buildCategoryGrid(context, provider),
                const SizedBox(height: 24),

                // Collections section
                _buildSectionHeader(
                  context,
                  '📦 Collections',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CollectionsScreen()),
                  ),
                ),
                const SizedBox(height: 8),
                _buildCollectionsPreview(context, provider),
                const SizedBox(height: 24),

                // Unused apps section
                if (provider.getUnusedApps(days: 30).isNotEmpty) ...[
                  _buildSectionHeader(context, '🗑️ Unused (30+ days)', () {}),
                  const SizedBox(height: 8),
                  _buildHorizontalAppList(
                    context,
                    provider.getUnusedApps(days: 30).take(8).toList(),
                    isUnused: true,
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: const Text('See all'),
          ),
      ],
    );
  }

  Widget _buildHorizontalAppList(BuildContext context, List<AppInfo> apps,
      {bool isUnused = false}) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: apps.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final app = apps[index];
          return _buildAppCircle(context, app, isUnused: isUnused);
        },
      ),
    );
  }

  Widget _buildAppCircle(BuildContext context, AppInfo app,
      {bool isUnused = false}) {
    return GestureDetector(
      onTap: () => context.read<AppProvider>().toggleFavorite(app.packageName),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isUnused
                    ? Colors.grey.shade200
                    : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  app.name.isNotEmpty ? app.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isUnused
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              app.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isUnused ? Colors.grey : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, AppProvider provider) {
    final categories = provider.categories;
    final counts = provider.categoryCounts;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final count = counts[cat] ?? 0;
        return _buildCategoryItem(context, cat, count);
      },
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category, int count) {
    final icon = _getCategoryIcon(category);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryDetailScreen(category: category),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionsPreview(BuildContext context, AppProvider provider) {
    final collections = provider.collections;
    if (collections.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text(
            'No collections yet. Create one to group your apps!',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: collections.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final collection = collections[index];
          return Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_rounded,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 4),
                Text(
                  collection.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${collection.appIds.length} apps',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        },
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

/// Full-screen view of all favorites.
class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final favorites = provider.favorites;
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No favorites yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Tap the star icon to favorite an app',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final app = favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        app.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  title: Text(app.name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(app.category,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.star, color: Color(0xFFEAB308)),
                    onPressed: () =>
                        provider.toggleFavorite(app.packageName),
                  ),
                  onTap: () => provider.markAsOpened(app.packageName),
                ),
              );
            },
          );
        },
      ),
    );
  }
}