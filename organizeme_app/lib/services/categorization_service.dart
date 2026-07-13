const Map<String, List<String>> _categoryKeywords = {
  'Social': [
    'facebook', 'instagram', 'twitter', 'tiktok', 'snapchat', 'linkedin',
    'discord', 'telegram', 'whatsapp', 'messenger', 'reddit', 'pinterest',
    'social', 'chat', 'message', 'threads', 'bluesky', 'mastodon',
  ],
  'Finance': [
    'bank', 'cash', 'pay', 'finance', 'money', 'wallet', 'venmo', 'paypal',
    'coinbase', 'robinhood', 'credit', 'invest', 'budget', 'savings',
    'capital one', 'chase', 'wells fargo', 'stripe', 'square', 'zelle',
  ],
  'Games': [
    'game', 'play', 'word', 'puzzle', 'clash', 'candy', 'angry', 'among',
    'mario', 'zynga', 'roblox', 'minecraft', 'fortnite', 'gaming', 'arcade',
    'chess', 'solitaire', 'rpg', 'strategy', 'king',
  ],
  'Music': [
    'music', 'spotify', 'apple music', 'sound', 'tune', 'podcast', 'shazam',
    'pandora', 'audio', 'song', 'playlist', 'radio', 'amplifier', 'band',
    'youtube music', 'deezer', 'tidal', 'iheart',
  ],
  'Photos': [
    'photo', 'camera', 'gallery', 'album', 'instagram', 'snapchat', 'lightroom',
    'edit', 'image', 'picture', 'snapseed', 'canva', 'picsart', 'vsco',
    'photography', 'filter', 'capture',
  ],
  'Health': [
    'health', 'fit', 'workout', 'run', 'step', 'sleep', 'meditate', 'strava',
    'myfitnesspal', 'gym', 'exercise', 'yoga', 'calorie', 'heart', 'weight',
    'nike run', 'fitbit', 'peloton', 'headspace', 'calm',
  ],
  'Travel': [
    'travel', 'flight', 'hotel', 'airbnb', 'uber', 'lyft', 'maps', 'navigate',
    'trip', 'airline', 'booking', 'expedia', 'hotels', 'motel', 'journey',
    'vacation', 'transit', 'train', 'gas', 'parking', 'google maps', 'waze',
    'delta', 'united', 'american airlines', 'southwest', 'kayak',
  ],
  'Shopping': [
    'shop', 'amazon', 'walmart', 'target', 'etsy', 'ebay', 'buy', 'cart',
    'deal', 'shopping', 'store', 'mall', 'retail', 'offer', 'coupon',
    'aliexpress', 'best buy', 'costco', 'macys', 'nordstrom', 'shein',
    'wish', 'mercado', 'flipkart',
  ],
  'Education': [
    'learn', 'course', 'school', 'canvas', 'duolingo', 'khan', 'quizlet',
    'google classroom', 'notion', 'study', 'education', 'college', 'university',
    'classroom', 'student', 'homework', 'grade', 'coursera', 'udemy', 'edx',
    'dictionary', 'translate', 'wikipedia',
  ],
  'Utilities': [
    'utility', 'tool', 'calculator', 'clock', 'weather', 'file', 'pdf', 'note',
    'google', 'drive', 'dropbox', 'setting', 'launcher', 'manager', 'scanner',
    'keyboard', 'browser', 'download', 'cleaner', 'vpn', 'password',
    'authenticator', 'widget', 'recorder', 'compass', 'flashlight',
  ],
  'Home': [
    'home', 'smart', 'iot', 'nest', 'ring', 'hue', 'alarm', 'light', 'energy',
    'garage', 'thermostat', 'ecobee', 'smartthings', 'alexa', 'google home',
    'roomba', 'security', 'camera', 'doorbell', 'sensor',
  ],
  'Work': [
    'work', 'office', 'slack', 'zoom', 'teams', 'outlook', 'calendar', 'doc',
    'sheet', 'slide', 'jira', 'trello', 'asana', 'notion', 'business',
    'meeting', 'email', 'invoice', 'project', 'task', 'productivity',
    'microsoft', 'google workspace', 'sheets', 'docs', 'lark', 'teams',
    'basecamp', 'monday', 'clickup',
  ],
};

class CategorizationService {
  /// Categorize an app based on its name and package name.
  /// Returns the category name, or 'Other' if no match.
  static String categorize(String name, String packageName) {
    final lowerName = name.toLowerCase();
    final lowerPackage = packageName.toLowerCase();
    final combined = '$lowerName $lowerPackage';

    for (final entry in _categoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (combined.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return 'Other';
  }

  /// Get all category names.
  static List<String> getCategories() => _categoryKeywords.keys.toList()..add('Other');

  /// Get sorted category list (Other always last).
  static List<String> getSortedCategories() {
    final cats = _categoryKeywords.keys.toList()..sort();
    cats.add('Other');
    return cats;
  }
}
