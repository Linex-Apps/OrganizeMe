import 'package:flutter/material.dart';
import '../services/premium_service.dart';
import '../services/stripe_config.dart';

/// A premium upsell modal showing plan comparison and purchase options.
class PremiumUpsellSheet extends StatefulWidget {
  const PremiumUpsellSheet({super.key});

  @override
  State<PremiumUpsellSheet> createState() => _PremiumUpsellSheetState();
}

class _PremiumUpsellSheetState extends State<PremiumUpsellSheet> {
  final PremiumService _service = PremiumService();
  bool _isMonthly = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Icon
          const Icon(Icons.stars_rounded, size: 64, color: Color(0xFFEAB308)),
          const SizedBox(height: 16),
          const Text(
            'Upgrade to Premium',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unlock the full OrganizeMe experience',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),

          // Plan toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isMonthly = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isMonthly
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Monthly',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _isMonthly
                                  ? const Color(0xFF2563EB)
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            StripeConfig.formatMonthly(),
                            style: TextStyle(
                              fontSize: 12,
                              color: _isMonthly
                                  ? const Color(0xFF2563EB)
                                  : Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isMonthly = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isMonthly
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Yearly',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: !_isMonthly
                                      ? const Color(0xFF2563EB)
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAB308),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'SAVE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            StripeConfig.formatYearly(),
                            style: TextStyle(
                              fontSize: 12,
                              color: !_isMonthly
                                  ? const Color(0xFF2563EB)
                                  : Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (!_isMonthly)
            Text(
              StripeConfig.yearlySavings,
              style: const TextStyle(
                color: Color(0xFFEAB308),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 20),

          // Feature list
          ...PremiumService.premiumFeatures.map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    f.isAvailable
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline_rounded,
                    color: f.isAvailable
                        ? const Color(0xFF4ADE80)
                        : Colors.white.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    f.name,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: f.isAvailable ? 1.0 : 0.6),
                      fontSize: 14,
                    ),
                  ),
                  if (!f.isAvailable)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAB308).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFEAB308),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Purchase button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                final priceId = _isMonthly
                    ? StripeConfig.monthlyPriceId
                    : StripeConfig.yearlyPriceId;
                final success = await _service.purchase(priceId);
                if (success && mounted) {
                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Welcome to Premium! 🎉')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAB308),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                _isMonthly
                    ? 'Subscribe \$${StripeConfig.monthlyPrice.toStringAsFixed(2)}/month'
                    : 'Subscribe \$${StripeConfig.yearlyPrice.toStringAsFixed(2)}/year',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Restore / Terms
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await _service.restorePurchases();
                },
                child: Text(
                  'Restore Purchases',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Privacy',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Terms',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Shows the premium upsell bottom sheet. Returns true if user subscribed.
Future<bool?> showPremiumUpsell(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const PremiumUpsellSheet(),
  );
}