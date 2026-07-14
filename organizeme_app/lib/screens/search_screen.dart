import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_info.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AppInfo> _results = [];
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final provider = context.read<AppProvider>();
    setState(() {
      _results = provider.search(query);
      _hasSearched = query.isNotEmpty;
    });
  }

  /// Group results by category, preserving order of appearance.
  Map<String, List<AppInfo>> _groupByCategory(List<AppInfo> apps) {
    final map = <String, List<AppInfo>>{};
    for (final app in apps) {
      map.putIfAbsent(app.category, () => []).add(app);
    }
    // Sort categories: named ones first, "Other" last
    final sortedKeys = map.keys.toList()
      ..sort((a, b) {
        if (a == 'Other') return 1;
        if (b == 'Other') return -1;
        return a.compareTo(b);
      });
    final sorted = <String, List<AppInfo>>{};
    for (final key in sortedKeys) {
      sorted[key] = map[key]!;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grouped = _groupByCategory(_results);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _onSearch,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search apps by name, category...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch('');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: _hasSearched
          ? _results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No apps found for "${_searchController.text}"',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      '${_results.length} result${_results.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...grouped.entries.map((entry) => _buildCategoryGroup(
                      context, entry.key, entry.value, theme,
                    )),
                  ],
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Search by app name, category, or keywords',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Results grouped by category',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryGroup(
    BuildContext context,
    String category,
    List<AppInfo> apps,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Row(
            children: [
              Icon(_getCategoryIcon(category), size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                category,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${apps.length}',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...apps.map((app) => _buildAppResult(context, app, theme)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAppResult(BuildContext context, AppInfo app, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              app.name.isNotEmpty ? app.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        title: Text(app.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text(app.packageName,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                app.isFavorite ? Icons.star : Icons.star_border,
                color: app.isFavorite ? const Color(0xFFEAB308) : Colors.grey.shade400,
                size: 20,
              ),
              onPressed: () {
                context.read<AppProvider>().toggleFavorite(app.packageName);
                setState(() {}); // Refresh UI
              },
            ),
            _buildAddToCollectionButton(context, app),
          ],
        ),
        onTap: () {
          context.read<AppProvider>().markAsOpened(app.packageName);
        },
      ),
    );
  }

  Widget _buildAddToCollectionButton(BuildContext context, AppInfo app) {
    return IconButton(
      icon: Icon(Icons.playlist_add_rounded, size: 20, color: Colors.grey.shade400),
      onPressed: () => _showAddToCollectionSheet(context, app),
    );
  }

  void _showAddToCollectionSheet(BuildContext context, AppInfo app) {
    final provider = context.read<AppProvider>();
    final collections = provider.collections;
    if (collections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create a collection first!')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Add "${app.name}" to...',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ...collections.map((collection) {
              final alreadyAdded = collection.appIds.contains(app.packageName);
              return ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(collection.color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.folder_rounded, color: Colors.white, size: 20),
                ),
                title: Text(collection.name),
                trailing: alreadyAdded
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.add_circle_outline),
                onTap: () {
                  if (!alreadyAdded) {
                    provider.addToCollection(collection.name, app.packageName);
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        alreadyAdded
                            ? 'Already in "${collection.name}"'
                            : 'Added to "${collection.name}"',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 8),
          ],
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