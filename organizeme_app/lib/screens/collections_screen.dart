import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/collection.dart';
import 'collection_detail_screen.dart';
import 'premium_upsell_screen.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Collections'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final collections = provider.collections;
          if (collections.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_rounded,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No collections yet',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create collections to group your apps',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateCollectionDialog(context, provider),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Collection'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              if (provider.collectionCount >= 3)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFFEF3C7),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: Color(0xFFEAB308), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Upgrade to Premium for unlimited collections!',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: collections.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildCreateCard(context, provider);
                    }
                    final collection = collections[index - 1];
                    return _buildCollectionCard(context, collection, provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCreateCard(BuildContext context, AppProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.add, color: Color(0xFF2563EB), size: 28),
        ),
        title: Text(
          provider.canCreateCollection
              ? 'Create New Collection'
              : 'Upgrade for More Collections',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${provider.collectionCount}/3 free collections used',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        trailing: provider.canCreateCollection
            ? const Icon(Icons.chevron_right)
            : const Icon(Icons.stars_rounded, color: Color(0xFFEAB308)),
        onTap: () => _showCreateCollectionDialog(context, provider),
      ),
    );
  }

  Widget _buildCollectionCard(
      BuildContext context, AppCollection collection, AppProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.folder_rounded,
              color: Theme.of(context).colorScheme.primary, size: 28),
        ),
        title: Text(
          collection.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${collection.appIds.length} app${collection.appIds.length != 1 ? 's' : ''}',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: () => _confirmDelete(context, provider, collection),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CollectionDetailScreen(collection: collection),
          ),
        ),
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context, AppProvider provider) {
    if (!provider.canCreateCollection) {
      showPremiumUpsell(context);
      return;
    }
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Collection'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Collection name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.createCollection(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, AppProvider provider, AppCollection collection) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Collection'),
        content: Text('Delete "${collection.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteCollection(collection.name);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}