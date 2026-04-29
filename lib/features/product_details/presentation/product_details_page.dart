import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants.dart';
import '../controller/product_controller.dart';
import '../../cart/presentation/controllar/cart_controller.dart';
import '../data/product.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  // ✅ Get.find فقط — مش Get.put
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  late String productId;
  Product? product;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    productId = Get.parameters['id'] ?? 'unknown';
    _loadProduct();
  }

  void _loadProduct() {
    product = productController.getProductById(productId);
    if (product == null) {
      productController.loadProducts().then((_) {
        if (mounted) {
          setState(() {
            product = productController.getProductById(productId);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          backgroundColor: kMainColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
              ),
              SizedBox(height: 16),
              Text(
                'Loading product details...',
                style: TextStyle(fontSize: 16, color: kTextLightColor),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Get.snackbar(
                'Share',
                'Share functionality coming soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(),
                  const SizedBox(height: 16),
                  _buildPriceSection(),
                  const SizedBox(height: 16),
                  _buildQuantitySelector(),
                  const SizedBox(height: 24),
                  _buildDescription(),
                  const SizedBox(height: 24),
                  _buildAddToCartButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 300,
      color: kBackgroundColor,
      child: product!.imageUrl.isNotEmpty
          ? Image.network(
              product!.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 80,
                    color: kTextLightColor,
                  ),
                );
              },
            )
          : const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 80,
                color: kTextLightColor,
              ),
            ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product!.category,
                style: const TextStyle(fontSize: 16, color: kTextLightColor),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (product!.isOrganic)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kSuccessColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Organic',
                  style: TextStyle(
                    fontSize: 12,
                    color: kSuccessColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (product!.hasDiscount)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kErrorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${product!.discountPercentage.toStringAsFixed(0)}% OFF',
                  style: TextStyle(
                    fontSize: 12,
                    color: kErrorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Text(
          '\$${product!.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: product!.hasDiscount ? kErrorColor : kMainColor,
          ),
        ),
        if (product!.hasDiscount && product!.originalPrice != null) ...[
          const SizedBox(width: 12),
          Text(
            '\$${product!.originalPrice!.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              color: kTextLightColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
        const Spacer(),
        Row(
          children: [
            Icon(Icons.star, color: kSecondaryColor, size: 20),
            const SizedBox(width: 4),
            Text(
              product!.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kBorderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  size: 20,
                  color: quantity > 1 ? kMainColor : kTextLightColor,
                ),
                onPressed: quantity > 1
                    ? () => setState(() => quantity--)
                    : null,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, size: 20, color: kMainColor),
                onPressed: () => setState(() => quantity++),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product!.description,
          style: const TextStyle(
            fontSize: 16,
            color: kTextLightColor,
            height: 1.5,
          ),
        ),
        if (product!.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product!.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return Obx(() {
      final isLoading = cartController.isLoading.value;
      final isInCart = cartController.isInCart(product!.id);
      final cartQuantity = cartController.getItemQuantity(product!.id);

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  // ✅ بيضيف الكمية المختارة دفعة واحدة
                  await cartController.addToCart(product!, quantity: quantity);
                  if (mounted) setState(() => quantity = 1);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: kMainColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isInCart
                          ? 'Add More ($cartQuantity in cart)'
                          : 'Add to Cart',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
