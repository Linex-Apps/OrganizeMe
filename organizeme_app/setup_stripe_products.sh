#!/bin/bash
# ==========================================================
# OrganizeMe — Stripe Product Setup Script
# ==========================================================
# Run this script after obtaining your Stripe secret key.
# It creates the monthly and yearly premium products + prices.
#
# Usage: STRIPE_SECRET_KEY=sk_live_xxx bash setup_stripe_products.sh
# For test mode: STRIPE_SECRET_KEY=sk_test_xxx bash setup_stripe_products.sh
#
# Prerequisites: curl, jq (optional for pretty output)
# ==========================================================

if [ -z "$STRIPE_SECRET_KEY" ]; then
  echo "ERROR: STRIPE_SECRET_KEY environment variable is required."
  echo "Usage: STRIPE_SECRET_KEY=sk_test_xxx bash $0"
  exit 1
fi

API_BASE="https://api.stripe.com/v1"
AUTH_HEADER="Authorization: Bearer $STRIPE_SECRET_KEY"

echo "=== Creating OrganizeMe Premium Products ==="

# 1. Create Premium Monthly product
echo ""
echo "--- Creating Premium Monthly product ---"
MONTHLY_PRODUCT=$(curl -s -X POST "$API_BASE/products" \
  -H "$AUTH_HEADER" \
  -d "name=OrganizeMe%20Premium%20Monthly" \
  -d "description=Unlimited%20collections%2C%20custom%20themes%2C%20cloud%20backup%20%26%20sync" \
  -d "metadata[app]=organizeme" \
  -d "metadata[tier]=premium" \
  -d "metadata[billing]=monthly")

MONTHLY_PRODUCT_ID=$(echo "$MONTHLY_PRODUCT" | grep -o '"id": *"[^"]*"' | head -1 | grep -o '"[^"]*"$' | tr -d '"')
echo "Product ID: $MONTHLY_PRODUCT_ID"

# 2. Create price for monthly ($2.99)
echo ""
echo "--- Creating Monthly Price (\$2.99) ---"
MONTHLY_PRICE=$(curl -s -X POST "$API_BASE/prices" \
  -H "$AUTH_HEADER" \
  -d "unit_amount=299" \
  -d "currency=usd" \
  -d "recurring[interval]=month" \
  -d "product=$MONTHLY_PRODUCT_ID")

MONTHLY_PRICE_ID=$(echo "$MONTHLY_PRICE" | grep -o '"id": *"[^"]*"' | head -1 | grep -o '"[^"]*"$' | tr -d '"')
echo "Price ID: $MONTHLY_PRICE_ID"

# 3. Create Premium Yearly product
echo ""
echo "--- Creating Premium Yearly product ---"
YEARLY_PRODUCT=$(curl -s -X POST "$API_BASE/products" \
  -H "$AUTH_HEADER" \
  -d "name=OrganizeMe%20Premium%20Yearly" \
  -d "description=Unlimited%20collections%2C%20custom%20themes%2C%20cloud%20backup%20%26%20sync%20%E2%80%94%20save%20%2423.89" \
  -d "metadata[app]=organizeme" \
  -d "metadata[tier]=premium" \
  -d "metadata[billing]=yearly")

YEARLY_PRODUCT_ID=$(echo "$YEARLY_PRODUCT" | grep -o '"id": *"[^"]*"' | head -1 | grep -o '"[^"]*"$' | tr -d '"')
echo "Product ID: $YEARLY_PRODUCT_ID"

# 4. Create price for yearly ($19.99)
echo ""
echo "--- Creating Yearly Price (\$19.99) ---"
YEARLY_PRICE=$(curl -s -X POST "$API_BASE/prices" \
  -H "$AUTH_HEADER" \
  -d "unit_amount=1999" \
  -d "currency=usd" \
  -d "recurring[interval]=year" \
  -d "product=$YEARLY_PRODUCT_ID")

YEARLY_PRICE_ID=$(echo "$YEARLY_PRICE" | grep -o '"id": *"[^"]*"' | head -1 | grep -o '"[^"]*"$' | tr -d '"')
echo "Price ID: $YEARLY_PRICE_ID"

# 5. Output summary
echo ""
echo "========================================="
echo "  SETUP COMPLETE!"
echo "========================================="
echo ""
echo "Update these values in lib/services/stripe_config.dart:"
echo ""
echo "  static const String publishableKey = 'pk_...';"
echo "  static const String monthlyPriceId = '$MONTHLY_PRICE_ID';"
echo "  static const String yearlyPriceId = '$YEARLY_PRICE_ID';"
echo ""
echo "Products created:"
echo "  - Monthly: $MONTHLY_PRODUCT_ID (\$$MONTHLY_PRICE_ID)"
echo "  - Yearly:  $YEARLY_PRODUCT_ID (\$$YEARLY_PRICE_ID)"
echo ""
echo "Test with Stripe CLI: stripe trigger payment_intent.succeeded"
echo "========================================="