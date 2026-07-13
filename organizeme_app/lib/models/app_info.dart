class AppInfo {
  final String name;
  final String packageName;
  String category;
  bool isFavorite;
  DateTime? lastOpenedAt;
  DateTime? installedDate;
  int usageCount;
  String? iconBase64;

  AppInfo({
    required this.name,
    required this.packageName,
    this.category = 'Other',
    this.isFavorite = false,
    this.lastOpenedAt,
    this.installedDate,
    this.usageCount = 0,
    this.iconBase64,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'packageName': packageName,
    'category': category,
    'isFavorite': isFavorite,
    'lastOpenedAt': lastOpenedAt?.toIso8601String(),
    'installedDate': installedDate?.toIso8601String(),
    'usageCount': usageCount,
    'iconBase64': iconBase64,
  };

  factory AppInfo.fromJson(Map<String, dynamic> json) => AppInfo(
    name: json['name'] as String? ?? '',
    packageName: json['packageName'] as String? ?? '',
    category: json['category'] as String? ?? 'Other',
    isFavorite: json['isFavorite'] as bool? ?? false,
    lastOpenedAt: json['lastOpenedAt'] != null
        ? DateTime.tryParse(json['lastOpenedAt'] as String)
        : null,
    installedDate: json['installedDate'] != null
        ? DateTime.tryParse(json['installedDate'] as String)
        : null,
    usageCount: json['usageCount'] as int? ?? 0,
    iconBase64: json['iconBase64'] as String?,
  );
}