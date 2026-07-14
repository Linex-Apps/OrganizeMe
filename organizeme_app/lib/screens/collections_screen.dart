import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/collection.dart';
import 'collection_detail_screen.dart';

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
              if (!provider.canCreateCollection)
                _buildPremiumBanner(context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: collections.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildCreateCard(context, provider);
                    }
                    final collection = collections[index - 1];
                    return _buildCollectionCard(context, collection, provider, theme);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFFEF3C7),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, color: Color(0xFFEAB308), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Upgrade to Premium for unlimited collections!',
              style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () => _showPremiumUpsell(context),
            child: const Text('Upgrade', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
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
            color: provider.canCreateCollection
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            provider.canCreateCollection ? Icons.add : Icons.stars_rounded,
            color: provider.canCreateCollection
                ? const Color(0xFF2563EB)
                : const Color(0xFFEAB308),
            size: 28,
          ),
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
        onTap: () {
          if (provider.canCreateCollection) {
            _showCreateCollectionDialog(context, provider);
          } else {
            _showPremiumUpsell(context);
          }
        },
      ),
    );
  }

  Widget _buildCollectionCard(
      BuildContext context, AppCollection collection, AppProvider provider, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(collection.color).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.folder_rounded,
              color: Color(collection.color), size: 28),
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
    final nameController = TextEditingController();
    int selectedColor = AppCollection.availableColors[0];
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Create Collection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Collection name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder_rounded),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Choose color:', style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppCollection.availableColors.map((color) {
                  final isSelected = color == selectedColor;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(color),
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2.5)
                            : null,
                        boxShadow: isSelected
                            ? [BoxShadow(
                                color: Color(color).withValues(alpha: 0.4),
                                blurRadius: 8,
                              )]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  provider.createCollection(
                    nameController.text.trim(),
                    color: selectedColor,
                  );
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(selectedColor),
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPremiumUpsell(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, size: 56, color: Color(0xFFEAB308)),
              const SizedBox(height: 16),
              const Text(
                'Upgrade to Premium',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const _PremiumFeature(text: 'Unlimited collections'),
              const _PremiumFeature(text: 'Custom icons & themes'),
              const _PremiumFeature(text: 'Cloud backup & sync'),
              const _PremiumFeature(text: 'Advanced usage stats'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAB308),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Upgrade for \$2.99/month',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Maybe later'),
              ),
            ],
          ),
        ),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PremiumFeature extends StatelessWidget {
  final String text;
  const _PremiumFeature({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 22),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}