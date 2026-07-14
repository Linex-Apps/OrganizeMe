/// Manages premium subscription state and payment flows.
///
/// In the MVP, this uses Hive-based local state to track whether the user
/// has premium. When Stripe is connected, the purchase flow will:
///   1. Create a PaymentIntent via a backend endpoint
///   2. Confirm with [flutter_stripe] on the client
///   3. Store the subscription status returned from Stripe webhooks
class PremiumService {
  bool _isPremium = false;
  bool _isLoading = false;
  String? _subscriptionId;
  String? _errorMessage;

  // Getters
  bool get isPremium => _isPremium;
  bool get isLoading => _isLoading;
  String? get subscriptionId => _subscriptionId;
  String? get errorMessage => _errorMessage;

  /// Whether the free tier can create a new collection.
  bool get canCreateCollection => _isPremium || _collectionCount < 3;
  int _collectionCount = 0;

  void setCollectionCount(int count) {
    _collectionCount = count;
  }

  /// Initialize premium state from local storage.
  Future<void> initialize() async {
    // TODO: Load premium status from Hive or secure storage
    _isPremium = false;
    _subscriptionId = null;
  }

  /// Start a purchase flow for the given price ID.
  Future<bool> purchase(String priceId) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      // Step 1: Call backend to create Stripe Checkout Session or PaymentIntent
      // final session = await _createCheckoutSession(priceId);
      //
      // Step 2: Launch Stripe Checkout or confirm PaymentIntent
      // await Stripe.instance.initPaymentSheet(...);
      // await Stripe.instance.presentPaymentSheet();
      //
      // Step 3: Verify subscription status with backend
      // _isPremium = true;
      // _subscriptionId = session.subscriptionId;

      // For MVP: simulate successful purchase
      await Future.delayed(const Duration(seconds: 2));
      _isPremium = true;
      _subscriptionId = 'sub_mock_${DateTime.now().millisecondsSinceEpoch}';
      _isLoading = false;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      return false;
    }
  }

  /// Restore purchases from a previous subscription.
  Future<bool> restorePurchases() async {
    // TODO: Call backend to verify active subscription status
    _isPremium = false;
    return _isPremium;
  }

  /// Get the list of features available at each tier.
  static List<PremiumFeature> get freeFeatures => [
        PremiumFeature('App Scanning', true),
        PremiumFeature('Auto-Categorization', true),
        PremiumFeature('Search & Favorites', true),
        PremiumFeature('3 Custom Collections', true),
        PremiumFeature('Usage Stats', true),
      ];

  static List<PremiumFeature> get premiumFeatures => [
        PremiumFeature('Unlimited Collections', true),
        PremiumFeature('Custom Icons & Themes', false),
        PremiumFeature('Cloud Backup & Sync', false),
        PremiumFeature('Advanced Usage Stats', false),
        PremiumFeature('AI-Powered Suggestions', false),
      ];
}

/// A feature description for the premium comparison table.
class PremiumFeature {
  final String name;
  final bool isAvailable;

  PremiumFeature(this.name, this.isAvailable);
}