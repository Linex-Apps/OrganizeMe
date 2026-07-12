/// Represents an installed app on the device.
class AppInfo {
  final String packageName;
  final String appName;
  final String? category;
  final String? iconBase64;

  const AppInfo({
    required this.packageName,
    required this.appName,
    this.category,
    this.iconBase64,
  });

  AppInfo copyWith({String? category}) {
    return AppInfo(
      packageName: packageName,
      appName: appName,
      category: category ?? this.category,
      iconBase64: iconBase64,
    );
  }
}

/// A category that apps can belong to.
class AppCategory {
  final String id;
  final String name;
  final String icon;
  final ColorIndex color;

  const AppCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.color = ColorIndex.blue,
  });
}

/// Predefined color options for categories.
enum ColorIndex {
  blue,
  yellow,
  green,
  red,
  purple,
  orange,
  teal,
  pink,
}

/// A user-created collection of apps.
class AppCollection {
  final String id;
  final String name;
  final String? icon;
  final List<String> appPackageNames;

  const AppCollection({
    required this.id,
    required this.name,
    this.icon,
    this.appPackageNames = const [],
  });
}