/// Configuration constants for OrganizeMe premium products on Stripe.
///
/// These product IDs are created and managed on the Stripe Dashboard.
/// The prices below are placeholders — replace with real Stripe price IDs
/// once the products are created via the Stripe CLI or Dashboard.
class StripeConfig {
  StripeConfig._();

  /// The Stripe publishable key for the client-side SDK.
  /// Set this via environment variable or build config.
  static const String publishableKey = 'pk_test_xxxxxxxxxxxxxxxxxxxx';

  /// Stripe Price IDs — replace with actual IDs from Stripe Dashboard.
  static const String monthlyPriceId = 'price_monthly_placeholder';
  static const String yearlyPriceId = 'price_yearly_placeholder';

  /// Human-readable product info.
  static const String monthlyName = 'Premium Monthly';
  static const String yearlyName = 'Premium Yearly';
  static const double monthlyPrice = 2.99;
  static const double yearlyPrice = 19.99;
  static const String monthlyCurrency = 'usd';
  static const String yearlyCurrency = 'usd';

  /// Returns the display string for a price, e.g. "\$2.99/month".
  static String formatMonthly() => '\$${monthlyPrice.toStringAsFixed(2)}/month';
  static String formatYearly() =>
      '\$${yearlyPrice.toStringAsFixed(2)}/year';
  static String formatMonthlyAnnual() =>
      '\$${monthlyPrice.toStringAsFixed(2)}';

  /// Savings message for yearly plan.
  static String get yearlySavings {
    final monthlyTotal = monthlyPrice * 12;
    final saved = monthlyTotal - yearlyPrice;
    return 'Save \$${saved.toStringAsFixed(2)}/year';
  }
}