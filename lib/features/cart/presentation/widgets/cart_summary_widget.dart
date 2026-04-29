import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../controllar/cart_controller.dart';

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Get.find فقط
    final CartController controller = Get.find<CartController>();

    return Obx(() {
      final cart = controller.cart;

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          border: Border.all(color: kBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...cart.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.product.name}',
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kMainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 20),
            _SummaryRow(
              label: 'Subtotal',
              value: '\$${controller.subtotal.toStringAsFixed(2)}',
            ),
            _SummaryRow(
              label: 'Shipping',
              value: controller.shippingCost == 0
                  ? 'Free'
                  : '\$${controller.shippingCost.toStringAsFixed(2)}',
            ),
            _SummaryRow(
              label: 'Tax (10%)',
              value: '\$${controller.tax.toStringAsFixed(2)}',
            ),
            if (controller.totalSavings > 0)
              _SummaryRow(
                label: 'You save',
                value: '-\$${controller.totalSavings.toStringAsFixed(2)}',
                color: kSuccessColor,
              ),
            const Divider(height: 20),
            _SummaryRow(
              label: 'Total',
              value: '\$${controller.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            if (controller.shippingCost > 0) ...[
              const SizedBox(height: 10),
              Text(
                'Add \$${(50.0 - controller.subtotal).toStringAsFixed(2)} more for free shipping',
                style: TextStyle(fontSize: 12, color: kTextLightColor),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? color;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? (isTotal ? kTextColor : kTextLightColor);
    final valueColor = color ?? (isTotal ? kMainColor : kTextColor);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
