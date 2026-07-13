import 'dart:math';
import '../models/app_info.dart';
import 'categorization_service.dart';

/// Mock app data for development (since device_apps won't work on web).
class MockAppData {
  static final List<Map<String, String>> _mockApps = [
    {'name': 'Facebook', 'package': 'com.facebook.katana'},
    {'name': 'Instagram', 'package': 'com.instagram.android'},
    {'name': 'Twitter', 'package': 'com.twitter.android'},
    {'name': 'TikTok', 'package': 'com.zhiliaoapp.musically'},
    {'name': 'Snapchat', 'package': 'com.snapchat.android'},
    {'name': 'LinkedIn', 'package': 'com.linkedin.android'},
    {'name': 'Discord', 'package': 'com.discord'},
    {'name': 'Telegram', 'package': 'org.telegram.messenger'},
    {'name': 'WhatsApp', 'package': 'com.whatsapp'},
    {'name': 'Reddit', 'package': 'com.reddit.frontpage'},
    {'name': 'Chase Bank', 'package': 'com.chase.sig.android'},
    {'name': 'PayPal', 'package': 'com.paypal.android.sdk'},
    {'name': 'Venmo', 'package': 'com.venmo'},
    {'name': 'Coinbase', 'package': 'com.coinbase.android'},
    {'name': 'Robinhood', 'package': 'com.robinhood.android'},
    {'name': 'Candy Crush', 'package': 'com.king.candycrushsaga'},
    {'name': 'Among Us', 'package': 'com.innersloth.spacemafia'},
    {'name': 'Roblox', 'package': 'com.roblox.client'},
    {'name': 'Minecraft', 'package': 'com.mojang.minecraftpe'},
    {'name': 'Spotify', 'package': 'com.spotify.music'},
    {'name': 'Apple Music', 'package': 'com.apple.android.music'},
    {'name': 'Shazam', 'package': 'com.shazam.android'},
    {'name': 'YouTube Music', 'package': 'com.google.android.apps.youtube.music'},
    {'name': 'Snapseed', 'package': 'com.niksoftware.snapseed'},
    {'name': 'Lightroom', 'package': 'com.adobe.lightroom'},
    {'name': 'Canva', 'package': 'com.canva.editor'},
    {'name': 'Google Photos', 'package': 'com.google.android.apps.photos'},
    {'name': 'Strava', 'package': 'com.strava'},
    {'name': 'MyFitnessPal', 'package': 'com.myfitnesspal.android'},
    {'name': 'Headspace', 'package': 'com.getsomeheadspace.android'},
    {'name': 'Calm', 'package': 'com.calm.android'},
    {'name': 'Uber', 'package': 'com.ubercab'},
    {'name': 'Airbnb', 'package': 'com.airbnb.android'},
    {'name': 'Expedia', 'package': 'com.expedia.bookings'},
    {'name': 'Google Maps', 'package': 'com.google.android.apps.maps'},
    {'name': 'Amazon', 'package': 'com.amazon.mShop.android.shopping'},
    {'name': 'Walmart', 'package': 'com.walmart.android'},
    {'name': 'eBay', 'package': 'com.ebay.mobile'},
    {'name': 'Etsy', 'package': 'com.etsy.android'},
    {'name': 'Duolingo', 'package': 'com.duolingo'},
    {'name': 'Khan Academy', 'package': 'org.khanacademy.android'},
    {'name': 'Quizlet', 'package': 'com.quizlet.quizletandroid'},
    {'name': 'Google Classroom', 'package': 'com.google.android.apps.classroom'},
    {'name': 'Notion', 'package': 'notion.id'},
    {'name': 'Google Drive', 'package': 'com.google.android.apps.docs'},
    {'name': 'Dropbox', 'package': 'com.dropbox.android'},
    {'name': 'Calculator', 'package': 'com.google.android.calculator'},
    {'name': 'Calendar', 'package': 'com.google.android.calendar'},
    {'name': 'Weather', 'package': 'com.google.android.apps.weather'},
    {'name': 'Google Chrome', 'package': 'com.android.chrome'},
    {'name': 'Nest', 'package': 'com.nest.android'},
    {'name': 'Ring', 'package': 'com.ringapp'},
    {'name': 'Slack', 'package': 'com.Slack'},
    {'name': 'Zoom', 'package': 'us.zoom.videomeetings'},
    {'name': 'Microsoft Teams', 'package': 'com.microsoft.teams'},
    {'name': 'Outlook', 'package': 'com.microsoft.office.outlook'},
    {'name': 'Trello', 'package': 'com.trello'},
    {'name': 'Jira', 'package': 'com.atlassian.android.jira.core'},
    {'name': 'Asana', 'package': 'com.asana.app'},
    {'name': 'Gmail', 'package': 'com.google.android.gm'},
    {'name': 'YouTube', 'package': 'com.google.android.youtube'},
    {'name': 'Netflix', 'package': 'com.netflix.mediaclient'},
    {'name': 'Settings', 'package': 'com.android.settings'},
    {'name': 'Clock', 'package': 'com.google.android.deskclock'},
    {'name': 'File Manager', 'package': 'com.android.documentsui'},
    {'name': 'Notes', 'package': 'com.miui.notes'},
    {'name': 'PDF Reader', 'package': 'com.adobe.reader'},
    {'name': 'Flashlight', 'package': 'com.android.flashlight'},
    {'name': 'Compass', 'package': 'com.google.android.compass'},
    {'name': 'Google Home', 'package': 'com.google.android.apps.chromecast.app'},
  ];

  static List<AppInfo> generateMockApps() {
    final random = Random();
    final now = DateTime.now();
    
    return _mockApps.map((app) {
      final daysAgo = random.nextInt(365);
      final lastOpened = random.nextBool() 
        ? now.subtract(Duration(days: random.nextInt(90)))
        : null;
      
      return AppInfo(
        name: app['name']!,
        packageName: app['package']!,
        category: CategorizationService.categorize(app['name']!, app['package']!),
        isFavorite: random.nextDouble() < 0.15,
        lastOpenedAt: lastOpened,
        installedDate: now.subtract(Duration(days: daysAgo)),
        usageCount: random.nextInt(200),
      );
    }).toList();
  }
}

class ScanningService {
  /// Scan installed apps. On web, returns mock data.
  /// On real devices, use device_apps package.
  static Future<List<AppInfo>> scanInstalledApps() async {
    // For now, return mock data for development
    // On actual Android/iOS devices, use device_apps package:
    // import 'package:device_apps/device_apps.dart';
    // final apps = await DeviceApps.getInstalledApplications(
    //   includeAppIcons: true,
    //   includeSystemApps: false,
    //   onlyAppsWithLaunchIntent: true,
    // );
    
    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));
    
    return MockAppData.generateMockApps();
  }

  /// Simulate a step-by-step scan for the animated onboarding experience.
  static Stream<int> scanWithProgress() async* {
    final total = MockAppData.generateMockApps().length;
    for (int i = 0; i <= total; i += 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield (i / total * 100).round();
    }
    yield 100;
  }
}