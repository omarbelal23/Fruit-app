import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/cart.dart';
import '../data/cart_item.dart';
import '../../../product_details/data/product.dart';
import '../../../../core/services/cart_service_interface.dart';
import '../../../../core/constants.dart';
import '../../../../core/utils/logger.dart';

class CartController extends GetxController {
  late CartServiceInterface _cartService;

  final Rx<Cart> _cart = Rx<Cart>(
    Cart(createdAt: DateTime.now(), updatedAt: DateTime.now()),
  );
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  Rx<Cart> get cartRx => _cart;
  RxBool get isLoading => _isLoading;

  Cart get cart => _cart.value;
  String get errorMessage => _errorMessage.value;
  int get itemCount => _cart.value.totalItems;
  double get subtotal => _cart.value.subtotal;
  double get shippingCost => _cart.value.shippingCost;
  double get tax => _cart.value.tax;
  double get total => _cart.value.total;
  bool get isEmpty => _cart.value.isEmpty;
  bool get isNotEmpty => _cart.value.isNotEmpty;

  double get totalSavings {
    return _cart.value.items.fold(0.0, (savings, item) {
      if (item.product.hasDiscount && item.product.originalPrice != null) {
        return savings +
            (item.product.originalPrice! - item.product.price) * item.quantity;
      }
      return savings;
    });
  }

  @override
  void onInit() {
    super.onInit();
    try {
      // ✅ setupDependencies في main.dart سجل CartServiceInterface قبل CartController
      // فـ Get.find هنا هيلاقيه جاهز دايماً
      _cartService = Get.find<CartServiceInterface>();
      loadCart();
      _listenToCartChanges();
    } catch (e) {
      AppLogger.error('Error initializing CartController', e);
      _errorMessage.value = 'Failed to initialize cart';
    }
  }

  Future<void> loadCart() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _cart.value = await _cartService.getCart();
    } catch (e) {
      _errorMessage.value = kGenericError;
      AppLogger.error('Error loading cart', e);
    } finally {
      _isLoading.value = false;
    }
  }

  void _listenToCartChanges() {
    _cartService.cartStream().listen(
      (cart) => _cart.value = cart,
      onError: (error) {
        AppLogger.error('Error in cart stream', error);
        _errorMessage.value = kGenericError;
      },
    );
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    if (quantity <= 0) {
      _showSnackbar('Error', 'Quantity must be greater than 0', isError: true);
      return;
    }

    try {
      _isLoading.value = true;
      _cart.value = await _cartService.addToCart(product, quantity: quantity);
      _showSnackbar('Added ✅', '${product.name} added to cart', isError: false);
    } catch (e) {
      _errorMessage.value = e.toString();
      AppLogger.error('Error adding to cart', e);
      _showSnackbar('Error', 'Failed to add item to cart', isError: true);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      _isLoading.value = true;
      _cart.value = await _cartService.removeFromCart(productId);
      _showSnackbar('Removed', 'Item removed from cart', isError: false);
    } catch (e) {
      _errorMessage.value = e.toString();
      AppLogger.error('Error removing from cart', e);
      _showSnackbar('Error', 'Failed to remove item', isError: true);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity < 0) return;
    if (quantity == 0) {
      await removeFromCart(productId);
      return;
    }

    try {
      _isLoading.value = true;
      _cart.value = await _cartService.updateQuantity(productId, quantity);
    } catch (e) {
      _errorMessage.value = e.toString();
      AppLogger.error('Error updating quantity', e);
      _showSnackbar('Error', 'Failed to update quantity', isError: true);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> increaseQuantity(String productId) async {
    await updateQuantity(productId, getItemQuantity(productId) + 1);
  }

  Future<void> decreaseQuantity(String productId) async {
    final current = getItemQuantity(productId);
    if (current > 1) await updateQuantity(productId, current - 1);
  }

  Future<void> clearCart() async {
    try {
      _isLoading.value = true;
      await _cartService.clearCart();
      _cart.value = Cart(createdAt: DateTime.now(), updatedAt: DateTime.now());
      _showSnackbar('Done', 'Cart cleared successfully', isError: false);
    } catch (e) {
      _errorMessage.value = e.toString();
      AppLogger.error('Error clearing cart', e);
      _showSnackbar('Error', 'Failed to clear cart', isError: true);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> applyCoupon(String couponCode) async {
    try {
      _isLoading.value = true;
      final result = await _cartService.applyCoupon(couponCode);
      if (result) {
        await loadCart();
        _showSnackbar('Success', 'Coupon applied!', isError: false);
      }
      return result;
    } catch (e) {
      AppLogger.error('Error applying coupon', e);
      _showSnackbar('Error', 'Invalid or expired coupon', isError: true);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  int getItemQuantity(String productId) =>
      _cart.value.getItemQuantity(productId);

  bool isInCart(String productId) =>
      _cart.value.items.any((item) => item.product.id == productId);

  CartItem? getCartItem(String productId) => _cart.value.items
      .cast<CartItem?>()
      .firstWhere((item) => item?.product.id == productId, orElse: () => null);

  void goToCart() => Get.toNamed('/cart');

  void goToCheckout() {
    if (isEmpty) {
      _showSnackbar('Empty Cart', 'Add items before checkout', isError: false);
      return;
    }
    Get.toNamed('/checkout');
  }

  void _showSnackbar(String title, String message, {required bool isError}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? kErrorColor : kSuccessColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
