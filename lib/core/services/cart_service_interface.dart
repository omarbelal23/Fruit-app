import '../../features/cart/presentation/data/cart.dart';
import '../../features/product_details/data/product.dart';

abstract class CartServiceInterface {
  Future<Cart> getCart();
  Future<Cart> addToCart(Product product, {int quantity = 1});
  Future<Cart> removeFromCart(String productId);
  Future<Cart> updateQuantity(String productId, int quantity);
  Future<Cart> clearCart();
  Stream<Cart> cartStream();
  
  // أضف هذه الدوال الجديدة
  Future<bool> applyCoupon(String couponCode);
  Future<bool> removeCoupon();
  double? getAppliedCouponDiscount();
  String? getAppliedCouponCode();
}