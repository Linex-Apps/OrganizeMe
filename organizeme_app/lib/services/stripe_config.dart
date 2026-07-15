/// Configuration constants for OrganizeMe premium products on Stripe.
///
/// These are the live Stripe price IDs and payment links.
class StripeConfig {
  StripeConfig._();

  /// Stripe Price IDs — live from the team's Stripe catalog.
  static const String monthlyPriceId = 'price_1TtBGKDJeVKa6LmHyGqMfAHt';
  static const String yearlyPriceId = 'price_1TtBGLDJeVKa6LmH2NRuu260';

  /// Stripe payment links for checkout (no backend needed).
  static const String monthlyPaymentLink =
      'https://buy.stripe.com/8x29AT5rG4HGfLH3ga2Ry0e';
  static const String yearlyPaymentLink =
      'https://buy.stripe.com/aFa9AT07m3DCfLHcQK2Ry0f';

  /// Human-readable product info.
  static const String monthlyName = 'Premium Monthly';
  static const String yearlyName = 'Premium Yearly';
  static const double monthlyPrice = 2.99;
  static const double yearlyPrice = 19.99;
  static const String monthlyCurrency = 'usd';
  static const String yearlyCurrency = 'usd';

  /// Returns the display string for a price, e.g. "$2.99/month".
  static String formatMonthly() =>
      '\$${monthlyPrice.toStringAsFixed(2)}/month';
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