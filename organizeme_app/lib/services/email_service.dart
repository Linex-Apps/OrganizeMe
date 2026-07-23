import 'package:flutter/foundation.dart';

/// Manages email subscription state for the shared Linex pipeline.
///
/// Currently stores subscription status in-memory. In production,
/// this would persist to Hive and sync to a shared Firebase/Firestore
/// endpoint accessible by all LinexApps products.
class EmailService {
  static final EmailService _instance = EmailService._();
  factory EmailService() => _instance;
  EmailService._();

  String? _subscribedEmail;
  bool _isPremium = false;

  // Getters
  String? get subscribedEmail => _subscribedEmail;
  bool get isSubscribed => _subscribedEmail != null;
  bool get isPremium => _isPremium;

  /// Subscribe an email from a given source.
  /// Returns true on success.
  Future<bool> subscribe(String email, {required String source}) async {
    // Validate email format
    if (!_isValidEmail(email)) return false;

    _subscribedEmail = email;

    // In production: POST to shared Linex endpoint
    // await _postToLinex(email: email, source: source, app: 'organizeme');

    debugPrint('[EmailService] Subscribed $email from $source');
    return true;
  }

  /// Mark this user as a premium subscriber (from Stripe checkout).
  void markAsPremium(String email) {
    _subscribedEmail = email;
    _isPremium = true;
    debugPrint('[EmailService] Premium subscriber: $email');
  }

  /// Unsubscribe the current email.
  Future<void> unsubscribe() async {
    final email = _subscribedEmail;
    _subscribedEmail = null;
    _isPremium = false;

    // In production: DELETE from shared endpoint
    debugPrint('[EmailService] Unsubscribed $email');
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email.trim());
  }
}
