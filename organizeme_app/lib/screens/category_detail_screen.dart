import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_info.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(category),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final apps = provider.getAppsInCategory(category);
          if (apps.isEmpty) {
            return const Center(child: Text('No apps in this category'));
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                child: Text(
                  '${apps.length} app${apps.length != 1 ? 's' : ''}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return _buildAppCard(context, app, theme, provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppCard(
      BuildContext context, AppInfo app, ThemeData theme, AppProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              app.name.isNotEmpty ? app.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        title: Text(
          app.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          app.packageName,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                app.isFavorite ? Icons.star : Icons.star_border,
                color: app.isFavorite ? const Color(0xFFEAB308) : Colors.grey,
              ),
              onPressed: () => provider.toggleFavorite(app.packageName),
            ),
            IconButton(
              icon: Icon(Icons.playlist_add_rounded,
                  color: Colors.grey.shade400, size: 20),
              onPressed: () => _showAddToCollectionSheet(context, app, provider),
            ),
          ],
        ),
        onTap: () => provider.markAsOpened(app.packageName),
      ),
    );
  }

  void _showAddToCollectionSheet(
      BuildContext context, AppInfo app, AppProvider provider) {
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
}