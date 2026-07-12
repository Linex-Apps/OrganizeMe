import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Search screen — find any app instantly.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _hasQuery = false;

  // Mock app results for preview
  final List<_MockApp> _allApps = const [
    _MockApp('Messages', Icons.chat_bubble_rounded, 'Social'),
    _MockApp('Calendar', Icons.calendar_month_rounded, 'Work'),
    _MockApp('Spotify', Icons.headphones_rounded, 'Entertainment'),
    _MockApp('Chrome', Icons.language_rounded, 'Utilities'),
    _MockApp('Gmail', Icons.mail_rounded, 'Work'),
    _MockApp('Maps', Icons.map_rounded, 'Travel'),
    _MockApp('Photos', Icons.photo_library_rounded, 'Photography'),
    _MockApp('Slack', Icons.chat_rounded, 'Work'),
    _MockApp('VS Code', Icons.code_rounded, 'Work'),
    _MockApp('Notion', Icons.article_rounded, 'Work'),
    _MockApp('Zoom', Icons.videocam_rounded, 'Work'),
    _MockApp('Calculator', Icons.calculate_rounded, 'Utilities'),
    _MockApp('YouTube', Icons.play_circle_rounded, 'Entertainment'),
    _MockApp('Netflix', Icons.tv_rounded, 'Entertainment'),
    _MockApp('Notes', Icons.note_rounded, 'Utilities'),
    _MockApp('Wallet', Icons.account_balance_wallet_rounded, 'Finance'),
  ];

  List<_MockApp> get _filteredApps {
    if (!_hasQuery) return [];
    final q = _searchController.text.toLowerCase();
    return _allApps
        .where((a) =>
            a.name.toLowerCase().contains(q) ||
            a.category.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredApps;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocus,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search your apps...',
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
          ),
          onChanged: (_) => setState(() => _hasQuery = _.isNotEmpty),
        ),
        actions: [
          if (_hasQuery)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _searchController.clear();
                setState(() => _hasQuery = false);
                _searchFocus.requestFocus();
              },
            ),
        ],
      ),
      body: _hasQuery
          ? results.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded, size: 64, color: AppColors.onSurfaceVariant),
                      SizedBox(height: 16),
                      Text('No apps found', style: TextStyle(fontSize: 18, color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 76),
                  itemBuilder: (_, i) {
                    final app = results[i];
                    return ListTile(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(app.icon, color: AppColors.primary, size: 24),
                      ),
                      title: Text(app.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(app.category, style: const TextStyle(color: AppColors.onSurfaceVariant)),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new_rounded, size: 20),
                        onPressed: () {},
                      ),
                      onTap: () {},
                    );
                  },
                )
          : const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_rounded, size: 64, color: AppColors.primary),
                  SizedBox(height: 16),
                  Text(
                    'Type to search across all your apps',
                    style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
    );
  }
}

class _MockApp {
  final String name;
  final IconData icon;
  final String category;

  const _MockApp(this.name, this.icon, this.category);
}