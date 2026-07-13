class AppCollection {
  final String name;
  List<String> appIds;
  final DateTime createdAt;

  AppCollection({
    required this.name,
    List<String>? appIds,
    DateTime? createdAt,
  }) : appIds = appIds ?? [],
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'name': name,
    'appIds': appIds,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AppCollection.fromJson(Map<String, dynamic> json) => AppCollection(
    name: json['name'] as String? ?? '',
    appIds: (json['appIds'] as List<dynamic>?)?.cast<String>() ?? [],
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
  );
}