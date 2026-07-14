import 'package:flutter/foundation.dart';
import '../models/app_info.dart';
import '../models/collection.dart';
import '../services/storage_service.dart';
import '../services/scanning_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storageService;
  
  AppProvider({required StorageService storageService})
      : _storageService = storageService;

  // --- State ---
  bool _isInitialized = false;
  bool _isScanning = false;
  int _scanProgress = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _hasScanned = false;

  bool get isInitialized => _isInitialized;
  bool get isScanning => _isScanning;
  int get scanProgress => _scanProgress;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get hasScanned => _hasScanned;

  // --- Init ---
  Future<void> initialize() async {
    if (_isInitialized) return;
    final apps = _storageService.getAllApps();
    _hasScanned = apps.isNotEmpty;
    _isInitialized = true;
    notifyListeners();
  }

  // --- App Scanning ---
  Future<void> scanApps() async {
    _isScanning = true;
    _scanProgress = 0;
    notifyListeners();

    final apps = await ScanningService.scanInstalledApps();
    await _storageService.saveAllApps(apps);
    
    _isScanning = false;
    _scanProgress = 100;
    _hasScanned = true;
    notifyListeners();
  }

  // --- Categories ---
  List<String> get categories => _getSortedCategories(apps);
  Map<String, int> get categoryCounts => _storageService.getCategoryCounts();

  List<AppInfo> get apps => _storageService.getAllApps();

  List<AppInfo> getAppsInCategory(String category) =>
      _storageService.getAppsByCategory(category);

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // --- Favorites ---
  List<AppInfo> get favorites => _storageService.getFavorites();

  Future<void> toggleFavorite(String packageName) async {
    await _storageService.toggleFavorite(packageName);
    notifyListeners();
  }

  // --- Recent & Frequent ---
  List<AppInfo> get recentApps => _storageService.getRecentApps();
  List<AppInfo> get frequentlyUsed => _storageService.getFrequentlyUsed();

  Future<void> markAsOpened(String packageName) async {
    await _storageService.markAsOpened(packageName);
    notifyListeners();
  }

  // --- Unused Apps ---
  List<AppInfo> getUnusedApps({int days = 30}) =>
      _storageService.getUnusedApps(days: days);

  // --- Search ---
  List<AppInfo> search(String query) {
    _searchQuery = query;
    if (query.isEmpty) return apps;
    return _storageService.searchApps(query);
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // --- Collections ---
  List<AppCollection> get collections => _storageService.getAllCollections();
  int get collectionCount => _storageService.getCollectionCount();
  bool get canCreateCollection => collectionCount < 3; // Free tier limit

  Future<void> createCollection(String name, {int color = 0xFF2563EB}) async {
    if (collectionCount >= 3) return; // Premium upsell
    final collection = AppCollection(name: name, color: color);
    await _storageService.saveCollection(collection);
    notifyListeners();
  }

  Future<void> updateCollectionColor(String name, int color) async {
    final collections = _storageService.getAllCollections();
    final idx = collections.indexWhere((c) => c.name == name);
    if (idx >= 0) {
      collections[idx].color = color;
      await _storageService.saveCollection(collections[idx]);
      notifyListeners();
    }
  }

  Future<void> addToCollection(String collectionName, String appId) async {
    await _storageService.addAppToCollection(collectionName, appId);
    notifyListeners();
  }

  Future<void> removeFromCollection(String collectionName, String appId) async {
    await _storageService.removeAppFromCollection(collectionName, appId);
    notifyListeners();
  }

  Future<void> deleteCollection(String name) async {
    await _storageService.deleteCollection(name);
    notifyListeners();
  }

  // --- Stats ---
  int get appCount => _storageService.getAppCount();

  // --- Helpers ---
  List<String> _getSortedCategories(List<AppInfo> appsList) {
    final catSet = appsList.map((a) => a.category).toSet();
    final cats = catSet.where((c) => c != 'Other').toList()..sort();
    if (catSet.contains('Other')) cats.add('Other');
    return cats;
  }
}