import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../cart/presentation/controllar/cart_controller.dart';
import '../../../../product_details/controller/product_controller.dart';
import '../../../../../core/constants.dart';
import '../product_card/product_card.dart';

class ProductListSection extends StatelessWidget {
  final ProductController productController;
  final CartController cartController;

  const ProductListSection({
    super.key,
    required this.productController,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Products Title
          const Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
          const SizedBox(height: 16),
          // Products Grid
          Obx(() {
            final products = productController.products;
            if (products.isEmpty && !productController.isLoading.value) {
              return _buildEmptyState();
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: kTextLightColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No products available',
              style: TextStyle(
                color: kTextLightColor.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
