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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return _buildAppCard(context, app, theme, provider);
            },
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
        trailing: IconButton(
          icon: Icon(
            app.isFavorite ? Icons.star : Icons.star_border,
            color: app.isFavorite ? const Color(0xFFEAB308) : Colors.grey,
          ),
          onPressed: () => provider.toggleFavorite(app.packageName),
        ),
        onTap: () => provider.markAsOpened(app.packageName),
      ),
    );
  }
}