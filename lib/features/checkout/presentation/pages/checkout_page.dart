import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/features/cart/presentation/controllar/cart_controller.dart';

import '../widgets/order_summary_widget.dart';
import '../widgets/delivery_address_widget.dart';
import '../widgets/payment_method_widget.dart';
import '../widgets/place_order_button_widget.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        return cartController.isEmpty
            ? const _EmptyCheckout()
            : const _CheckoutContent();
      }),
    );
  }
}

class _EmptyCheckout extends StatelessWidget {
  const _EmptyCheckout();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: kTextLightColor,
            ),
            const SizedBox(height: 18),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Add some products to your cart before checking out.',
              style: TextStyle(
                fontSize: 16,
                color: kTextLightColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(kDefaultBorderRadius),
                ),
              ),
              child: const Text(
                'Browse Products',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutContent extends StatelessWidget {
  const _CheckoutContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SectionTitle(title: 'Order Summary'),
        SizedBox(height: 12),
        OrderSummaryWidget(),

        SizedBox(height: 24),

        _SectionTitle(title: 'Delivery Address'),
        SizedBox(height: 12),
        DeliveryAddressWidget(),

        SizedBox(height: 24),

        _SectionTitle(title: 'Payment Method'),
        SizedBox(height: 12),
        PaymentMethodWidget(),

        SizedBox(height: 32),

        PlaceOrderButtonWidget(),

        SizedBox(height: 16),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getIcon(),
          color: kMainColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
      ],
    );
  }

  IconData _getIcon() {
    switch (title) {
      case 'Order Summary':
        return Icons.receipt_long;
      case 'Delivery Address':
        return Icons.location_on;
      case 'Payment Method':
        return Icons.payment;
      default:
        return Icons.info;
    }
  }
}