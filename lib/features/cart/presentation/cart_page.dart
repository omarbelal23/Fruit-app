import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants.dart';
import 'controllar/cart_controller.dart';
import 'widgets/cart_item_widget.dart';
import 'widgets/cart_summary_widget.dart';
import 'widgets/checkout_button_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Get.find فقط
    final CartController controller = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() {
            if (controller.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear_all_rounded),
                onPressed: () => _showClearCartDialog(controller),
                tooltip: 'Clear Cart',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
            ),
          );
        }

        if (controller.isEmpty) return _buildEmptyCart();

        return _buildCartWithItems(controller);
      }),
    );
  }

  Widget _buildEmptyCart() {
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
              'Add products to your cart to view them here.',
              style: TextStyle(
                fontSize: 15,
                color: kTextLightColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.offAllNamed('/home'),
              icon: const Icon(Icons.storefront_rounded, size: 18),
              label: const Text(
                'Browse Products',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartWithItems(CartController controller) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.cart.items.length,
            itemBuilder: (context, index) {
              final item = controller.cart.items[index];
              return CartItemWidget(
                key: ValueKey(item.product.id),
                cartItem: item,
                onIncrease: () => controller.increaseQuantity(item.product.id),
                onDecrease: () => _handleDecrease(controller, item.product.id),
                onRemove: () =>
                    _showRemoveItemDialog(controller, item.product.id),
              );
            },
          ),
        ),
        const CartSummaryWidget(),
        const CheckoutButtonWidget(),
      ],
    );
  }

  void _handleDecrease(CartController controller, String productId) {
    if (controller.getItemQuantity(productId) == 1) {
      _showRemoveItemDialog(controller, productId);
    } else {
      controller.decreaseQuantity(productId);
    }
  }

  void _showClearCartDialog(CartController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('Cancel', style: TextStyle(color: kTextLightColor)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearCart();
            },
            style: TextButton.styleFrom(foregroundColor: kErrorColor),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showRemoveItemDialog(CartController controller, String productId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Item'),
        content: const Text('Remove this item from your cart?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('Cancel', style: TextStyle(color: kTextLightColor)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeFromCart(productId);
            },
            style: TextButton.styleFrom(foregroundColor: kErrorColor),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
