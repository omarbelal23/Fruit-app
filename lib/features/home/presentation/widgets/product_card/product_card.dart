import 'package:flutter/material.dart';
import 'package:fruit_app/features/cart/presentation/controllar/cart_controller.dart';
import 'package:get/get.dart';
import '../../../../../core/constants.dart';
import '../../../../product_details/data/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed('/product/${product.id}'),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: kBorderColor.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: kBackgroundColor,
                    ),
                    child: _buildProductImage(),
                  ),
                  if (product.hasDiscount) _buildDiscountBadge(),
                  if (product.isOrganic) _buildOrganicBadge(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: _buildProductInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: kBackgroundColor,
          child: Icon(
            Icons.image_not_supported_outlined,
            color: kTextLightColor.withValues(alpha: 0.3),
            size: 40,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
            color: kMainColor,
          ),
        );
      },
    );
  }

  Widget _buildDiscountBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: kAccentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '-${product.discountPercentage.toStringAsFixed(0)}%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildOrganicBadge() {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: kSuccessColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Organic',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 4),
        _buildRatingRow(),
        const SizedBox(height: 6),
        _buildPriceRow(),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < product.rating.toInt() ? Icons.star : Icons.star_border,
            size: 12,
            color: kAccentColor,
          );
        }),
        const SizedBox(width: 4),
        Text(
          '(${product.reviewCount})',
          style: TextStyle(fontSize: 10, color: kTextLightColor),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kMainColor,
              ),
            ),
            if (product.hasDiscount)
              Text(
                '\$${product.originalPrice?.toStringAsFixed(2) ?? ''}',
                style: TextStyle(
                  fontSize: 11,
                  color: kTextLightColor,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
        GestureDetector(
          onTap: () {
            // ✅ الإصلاح — بدل 'Coming soon'
            if (!Get.isRegistered<CartController>()) {
              Get.put<CartController>(CartController());
            }
            final cartController = Get.find<CartController>();
            cartController.addToCart(product);

            Get.snackbar(
              'Added to Cart ✅',
              '${product.name} added successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: kSuccessColor.withValues(alpha: 0.9),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(12),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
