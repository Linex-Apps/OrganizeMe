import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_info.dart';
import '../models/collection.dart';

class StorageService {
  static const String _appsBoxName = 'organizeme_apps';
  static const String _collectionsBoxName = 'organizeme_collections';
  
  late Box<String> _appsBox;
  late Box<String> _collectionsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _appsBox = await Hive.openBox<String>(_appsBoxName);
    _collectionsBox = await Hive.openBox<String>(_collectionsBoxName);
  }

  // --- Apps ---
  List<AppInfo> getAllApps() {
    return _appsBox.values.map((json) => AppInfo.fromJson(jsonDecode(json))).toList();
  }
  
  AppInfo? getApp(String key) {
    final json = _appsBox.get(key);
    return json != null ? AppInfo.fromJson(jsonDecode(json)) : null;
  }
  
  Future<void> saveApp(AppInfo app) async {
    await _appsBox.put(app.packageName, jsonEncode(app.toJson()));
  }
  
  Future<void> saveAllApps(List<AppInfo> apps) async {
    for (final app in apps) {
      await _appsBox.put(app.packageName, jsonEncode(app.toJson()));
    }
  }
  
  Future<void> deleteApp(String key) async => _appsBox.delete(key);
  
  Future<void> toggleFavorite(String key) async {
    final app = getApp(key);
    if (app != null) {
      app.isFavorite = !app.isFavorite;
      await saveApp(app);
    }
  }
  
  Future<void> markAsOpened(String key) async {
    final app = getApp(key);
    if (app != null) {
      app.lastOpenedAt = DateTime.now();
      app.usageCount++;
      await saveApp(app);
    }
  }

  List<AppInfo> getFavorites() => 
    getAllApps().where((a) => a.isFavorite).toList();

  List<AppInfo> getRecentApps() {
    final apps = getAllApps()
      .where((a) => a.lastOpenedAt != null)
      .toList();
    apps.sort((a, b) => b.lastOpenedAt!.compareTo(a.lastOpenedAt!));
    return apps;
  }

  List<AppInfo> getFrequentlyUsed() {
    final apps = getAllApps();
    apps.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return apps;
  }

  List<AppInfo> getAppsByCategory(String category) =>
    getAllApps().where((a) => a.category == category).toList();

  List<AppInfo> getUnusedApps({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return getAllApps()
      .where((a) => a.lastOpenedAt == null || a.lastOpenedAt!.isBefore(cutoff))
      .toList();
  }

  int getAppCount() => _appsBox.length;

  Map<String, int> getCategoryCounts() {
    final counts = <String, int>{};
    for (final app in getAllApps()) {
      counts[app.category] = (counts[app.category] ?? 0) + 1;
    }
    return counts;
  }

  List<AppInfo> searchApps(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return getAllApps().where((app) =>
      app.name.toLowerCase().contains(lowerQuery) ||
      app.packageName.toLowerCase().contains(lowerQuery) ||
      app.category.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // --- Collections ---
  List<AppCollection> getAllCollections() {
    return _collectionsBox.values
        .map((json) => AppCollection.fromJson(jsonDecode(json)))
        .toList();
  }
  
  Future<void> saveCollection(AppCollection collection) async {
    await _collectionsBox.put(collection.name, jsonEncode(collection.toJson()));
  }
  
  Future<void> deleteCollection(String name) async {
    await _collectionsBox.delete(name);
  }

  Future<void> addAppToCollection(String collectionName, String appId) async {
    final json = _collectionsBox.get(collectionName);
    if (json != null) {
      final collection = AppCollection.fromJson(jsonDecode(json));
      if (!collection.appIds.contains(appId)) {
        collection.appIds.add(appId);
        await _collectionsBox.put(collectionName, jsonEncode(collection.toJson()));
      }
    }
  }

  Future<void> removeAppFromCollection(String collectionName, String appId) async {
    final json = _collectionsBox.get(collectionName);
    if (json != null) {
      final collection = AppCollection.fromJson(jsonDecode(json));
      collection.appIds.remove(appId);
      await _collectionsBox.put(collectionName, jsonEncode(collection.toJson()));
    }
  }

  int getCollectionCount() => _collectionsBox.length;
}