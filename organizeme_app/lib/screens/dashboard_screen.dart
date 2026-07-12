import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Main dashboard screen — the app's central hub.
class DashboardScreen extends StatelessWidget {
  final String userName;

  const DashboardScreen({super.key, this.userName = ''});

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final displayName = userName.isNotEmpty ? userName : 'there';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, $displayName 👋',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Text(
              'Your apps are organized',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
            tooltip: 'Search apps',
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {},
            tooltip: 'Filter',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ---- Favorites Row ----
          _SectionHeader(title: 'Favorites', onSeeAll: () {}),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _FavoriteAppTile(
                name: ['Messages', 'Mail', 'Photos', 'Music', 'Maps'][i],
                icon: [Icons.chat_bubble, Icons.mail, Icons.photo_library,
                        Icons.music_note, Icons.map][i],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ---- Recent Apps ----
          _SectionHeader(title: 'Recently Used', onSeeAll: () {}),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 8,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => _RecentAppTile(
                name: ['Chrome', 'Slack', 'VS Code', 'Notion', 'Spotify',
                        'Calendar', 'Notes', 'Zoom'][i],
                icon: [Icons.language, Icons.chat, Icons.code, Icons.article,
                        Icons.headphones, Icons.calendar_month, Icons.note, Icons.videocam][i],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---- Categories Grid ----
          _SectionHeader(title: 'Categories', onSeeAll: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
              children: const [
                _CategoryTile(name: 'Social', icon: Icons.people_rounded, count: 12, color: AppColors.primary),
                _CategoryTile(name: 'Work', icon: Icons.work_rounded, count: 8, color: AppColors.accent),
                _CategoryTile(name: 'Entertainment', icon: Icons.movie_rounded, count: 15, color: AppColors.success),
                _CategoryTile(name: 'Finance', icon: Icons.account_balance_rounded, count: 4, color: AppColors.error),
                _CategoryTile(name: 'Health', icon: Icons.favorite_rounded, count: 5, color: Color(0xFFEC4899)),
                _CategoryTile(name: 'Travel', icon: Icons.flight_rounded, count: 6, color: Color(0xFF8B5CF6)),
                _CategoryTile(name: 'Shopping', icon: Icons.shopping_bag_rounded, count: 7, color: Color(0xFFF97316)),
                _CategoryTile(name: 'Education', icon: Icons.school_rounded, count: 3, color: Color(0xFF14B8A6)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ---- Collections ----
          _SectionHeader(title: 'Collections', onSeeAll: () {}),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _CollectionCard(
                name: ['Work Tools', 'Weekend Fun', 'Travel Kit', 'Creative Suite'][i],
                icon: [Icons.work_history, Icons.sports_esports, Icons.luggage, Icons.palette][i],
                appCount: [6, 4, 5, 3][i],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---- Unused Apps ----
          _SectionHeader(title: 'Unused Apps (30+ days)', onSeeAll: () {}),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => _UnusedAppChip(
                name: ['Old Game', 'Expired VPN', 'Test App'][i],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

// ---- Reusable Widgets ----

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Row(
              children: [
                Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteAppTile extends StatelessWidget {
  final String name;
  final IconData icon;

  const _FavoriteAppTile({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 28),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 68,
          child: Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }
}

class _RecentAppTile extends StatelessWidget {
  final String name;
  final IconData icon;

  const _RecentAppTile({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final int count;
  final Color color;

  const _CategoryTile({
    required this.name,
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          Text(
            '$count apps',
            style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final int appCount;

  const _CollectionCard({
    required this.name,
    required this.icon,
    required this.appCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.folder_rounded, color: AppColors.primary, size: 22),
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            '$appCount apps',
            style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _UnusedAppChip extends StatelessWidget {
  final String name;

  const _UnusedAppChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Color.lerp(AppColors.error, AppColors.white, 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.error),
          const SizedBox(width: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 13, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}