import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Collections list screen — shows all user-created collections.
class CollectionsListScreen extends StatelessWidget {
  const CollectionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateCollectionScreen()),
              );
            },
            tooltip: 'New collection',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Existing collections
          _CollectionCard(
            name: 'Work Tools',
            appCount: 6,
            color: AppColors.primary,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CollectionDetailScreen(name: 'Work Tools')),
            ),
          ),
          const SizedBox(height: 12),
          _CollectionCard(
            name: 'Weekend Fun',
            appCount: 4,
            color: AppColors.accent,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CollectionDetailScreen(name: 'Weekend Fun')),
            ),
          ),
          const SizedBox(height: 12),
          _CollectionCard(
            name: 'Travel Kit',
            appCount: 5,
            color: const Color(0xFF8B5CF6),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CollectionDetailScreen(name: 'Travel Kit')),
            ),
          ),
          const SizedBox(height: 12),
          _CollectionCard(
            name: 'Creative Suite',
            appCount: 3,
            color: const Color(0xFFEC4899),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CollectionDetailScreen(name: 'Creative Suite')),
            ),
          ),

          const SizedBox(height: 24),

          // Add collection button
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateCollectionScreen()),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Collection'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),

          const SizedBox(height: 12),

          // Free tier limit info
          const Center(
            child: Text(
              'Free: 3 collections • Premium: Unlimited',
              style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

/// Create/edit collection screen.
class CreateCollectionScreen extends StatefulWidget {
  final String? existingName;

  const CreateCollectionScreen({super.key, this.existingName});

  @override
  State<CreateCollectionScreen> createState() => _CreateCollectionScreenState();
}

class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
  final _nameController = TextEditingController();
  final _colorValue = ValueNotifier<Color>(AppColors.primary);

  final List<Color> _colorOptions = const [
    AppColors.primary,
    AppColors.accent,
    Color(0xFF8B5CF6), // purple
    Color(0xFFEC4899), // pink
    Color(0xFFF97316), // orange
    Color(0xFF14B8A6), // teal
    Color(0xFF16A34A), // green
    Color(0xFFEF4444), // red
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingName != null) {
      _nameController.text = widget.existingName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existingName != null ? 'Edit Collection' : 'New Collection')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            const Text('Collection Name', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'e.g. Work Tools'),
            ),
            const SizedBox(height: 28),
            // Color picker
            const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            ValueListenableBuilder<Color>(
              valueListenable: _colorValue,
              builder: (_, color, __) => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colorOptions.map((c) {
                  final selected = c == color;
                  return GestureDetector(
                    onTap: () => _colorValue.value = c,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? AppColors.onSurface : Colors.transparent,
                          width: selected ? 3 : 0,
                        ),
                        boxShadow: selected
                            ? [BoxShadow(color: c.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: selected
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            // Save button
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
              ),
              child: const Text('Save Collection'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Collection detail screen — shows apps in a collection.
class CollectionDetailScreen extends StatelessWidget {
  final String name;

  const CollectionDetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {},
            tooltip: 'Edit collection',
          ),
          PopupMenuButton<String>(
            onSelected: (v) {},
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'rename', child: Text('Rename')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Add apps button
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Apps'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          ),
          const SizedBox(height: 16),

          // Placeholder: no apps yet
          ...List.generate(4, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.apps_rounded, color: AppColors.primary),
              ),
              title: Text('App ${i + 1}'),
              subtitle: const Text('Tap to open'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                onPressed: () {},
              ),
            ),
          )),
        ],
      ),
    );
  }
}

/// Reusable collection card for the list.
class _CollectionCard extends StatelessWidget {
  final String name;
  final int appCount;
  final Color color;
  final VoidCallback onTap;

  const _CollectionCard({
    required this.name,
    required this.appCount,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.folder_rounded, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text('$appCount apps', style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}