class AppCollection {
  final String name;
  List<String> appIds;
  final DateTime createdAt;
  int color;

  static const List<int> availableColors = [
    0xFF2563EB, // Royal blue
    0xFFEAB308, // Yellow
    0xFFEF4444, // Red
    0xFF22C55E, // Green
    0xFFA855F7, // Purple
    0xFFEC4899, // Pink
    0xFF14B8A6, // Teal
    0xFFF97316, // Orange
  ];

  AppCollection({
    required this.name,
    List<String>? appIds,
    DateTime? createdAt,
    this.color = 0xFF2563EB,
  }) : appIds = appIds ?? [],
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'name': name,
    'appIds': appIds,
    'createdAt': createdAt.toIso8601String(),
    'color': color,
  };

  factory AppCollection.fromJson(Map<String, dynamic> json) => AppCollection(
    name: json['name'] as String? ?? '',
    appIds: (json['appIds'] as List<dynamic>?)?.cast<String>() ?? [],
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
    color: json['color'] as int? ?? 0xFF2563EB,
  );
}