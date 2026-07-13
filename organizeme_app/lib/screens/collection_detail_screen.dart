import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/collection.dart';
import '../models/app_info.dart';

class CollectionDetailScreen extends StatelessWidget {
  final AppCollection collection;
  const CollectionDetailScreen({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(collection.name),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Edit collection - for future enhancement
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final allApps = provider.apps;
          final collectionApps = allApps
              .where((app) => collection.appIds.contains(app.packageName))
              .toList();
          final availableApps = allApps
              .where((app) => !collection.appIds.contains(app.packageName))
              .toList();

          if (collectionApps.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_rounded,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('No apps in this collection yet'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        _showAddAppsDialog(context, provider, availableApps),
                    child: const Text('Add Apps'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${collectionApps.length} app${collectionApps.length != 1 ? 's' : ''}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: collectionApps.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddAppsDialog(
                              context, provider, availableApps),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Apps'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.primary.withValues(alpha: 0.1),
                            foregroundColor: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    }
                    final app = collectionApps[index - 1];
                    return _buildAppCard(context, app, provider, theme);
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
      BuildContext context, AppInfo app, AppProvider provider, ThemeData theme) {
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
        title: Text(app.name),
        subtitle: Text(app.category,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
          onPressed: () {
            provider.removeFromCollection(collection.name, app.packageName);
          },
        ),
      ),
    );
  }

  void _showAddAppsDialog(
      BuildContext context, AppProvider provider, List<AppInfo> availableApps) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Add Apps to "${collection.name}"',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: availableApps.isEmpty
                    ? const Center(child: Text('All apps already added'))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: availableApps.length,
                        itemBuilder: (_, i) {
                          final app = availableApps[i];
                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  app.name[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(app.name),
                            subtitle: Text(app.category,
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 12)),
                            trailing: const Icon(Icons.add_circle_outline),
                            onTap: () {
                              provider.addToCollection(
                                  collection.name, app.packageName);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}