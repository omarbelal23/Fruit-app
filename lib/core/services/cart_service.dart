import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/core/services/cart_service_interface.dart';
import 'package:fruit_app/core/utils/logger.dart';
import 'package:fruit_app/features/cart/presentation/data/cart.dart';
import 'package:fruit_app/features/cart/presentation/data/cart_item.dart';
import 'package:fruit_app/features/product_details/data/product.dart';

class CartService implements CartServiceInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // متغيرات لتخزين بيانات الكوبون
  String? _appliedCouponCode;
  double? _appliedCouponDiscount;
  String? _couponError;

  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  // Get cart reference for current user
  DocumentReference<Map<String, dynamic>> get _cartRef {
    if (_userId == null) throw Exception('User not authenticated');
    return _firestore
        .collection(kUsersCollection)
        .doc(_userId)
        .collection(kCartCollection)
        .doc('current');
  }

  // Reference for coupon data
  DocumentReference<Map<String, dynamic>> get _couponRef {
    if (_userId == null) throw Exception('User not authenticated');
    return _firestore
        .collection(kUsersCollection)
        .doc(_userId)
        .collection('coupons')
        .doc('current');
  }

  // Get current cart
  Future<Cart> getCart() async {
    try {
      if (_userId == null) {
        return Cart(
          items: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      final doc = await _cartRef.get();
      if (doc.exists && doc.data() != null) {
        return Cart.fromJson(doc.data()!);
      } else {
        // Create empty cart if doesn't exist
        final emptyCart = Cart(
          items: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _cartRef.set(emptyCart.toJson());
        return emptyCart;
      }
    } catch (e) {
      AppLogger.error('Error getting cart', e);
      return Cart(
        items: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  // Add item to cart
  Future<Cart> addToCart(Product product, {int quantity = 1}) async {
    try {
      final cart = await getCart();
      final cartItem = CartItem(
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
      );

      final updatedCart = cart.addItem(cartItem);
      await _cartRef.set(updatedCart.toJson());
      return updatedCart;
    } catch (e) {
      AppLogger.error('Error adding to cart', e);
      throw Exception(kGenericError);
    }
  }

  // Remove item from cart
  Future<Cart> removeFromCart(String productId) async {
    try {
      final cart = await getCart();
      final updatedCart = cart.removeItem(productId);
      await _cartRef.set(updatedCart.toJson());
      return updatedCart;
    } catch (e) {
      AppLogger.error('Error removing from cart', e);
      throw Exception(kGenericError);
    }
  }

  // Update item quantity
  Future<Cart> updateQuantity(String productId, int quantity) async {
    try {
      final cart = await getCart();
      final updatedCart = cart.updateItemQuantity(productId, quantity);
      await _cartRef.set(updatedCart.toJson());
      return updatedCart;
    } catch (e) {
      AppLogger.error('Error updating quantity', e);
      throw Exception(kGenericError);
    }
  }

  // Clear cart
  @override
  Future<Cart> clearCart() async {
    try {
      final emptyCart = Cart(
        items: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _cartRef.set(emptyCart.toJson());

      // Also clear coupon when cart is cleared
      await _clearCouponData();

      return emptyCart;
    } catch (e) {
      print('Error clearing cart: $e');
      throw Exception(kGenericError);
    }
  }

  // Clear coupon data
  Future<void> _clearCouponData() async {
    _appliedCouponCode = null;
    _appliedCouponDiscount = null;
    await _couponRef.delete();
  }

  // Get cart item count (for badge)
  Future<int> getCartItemCount() async {
    try {
      final cart = await getCart();
      return cart.totalItems;
    } catch (e) {
      print('Error getting cart item count: $e');
      return 0;
    }
  }

  // Check if product is in cart
  Future<bool> isInCart(String productId) async {
    try {
      final cart = await getCart();
      return cart.items.any((item) => item.product.id == productId);
    } catch (e) {
      print('Error checking if in cart: $e');
      return false;
    }
  }

  // Stream cart changes
  Stream<Cart> cartStream() {
    if (_userId == null) {
      return Stream.value(
        Cart(items: [], createdAt: DateTime.now(), updatedAt: DateTime.now()),
      );
    }

    return _cartRef.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Cart.fromJson(snapshot.data()!);
      } else {
        return Cart(
          items: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    });
  }

  // Apply coupon code
  @override
  Future<bool> applyCoupon(String couponCode) async {
    try {
      // التحقق من صحة الكوبون
      final isValid = await _validateCoupon(couponCode);

      if (!isValid) {
        _couponError = 'Invalid or expired coupon';
        return false;
      }

      // حساب الخصم
      final cart = await getCart();
      final discount = await _calculateDiscount(couponCode, cart.subtotal);

      if (discount <= 0) {
        _couponError = 'Coupon does not apply to this cart';
        return false;
      }

      // حفظ بيانات الكوبون
      _appliedCouponCode = couponCode;
      _appliedCouponDiscount = discount;

      // حفظ في Firebase
      await _couponRef.set({
        'code': couponCode,
        'discount': discount,
        'appliedAt': FieldValue.serverTimestamp(),
      });

      _couponError = null;
      return true;
    } catch (e) {
      AppLogger.error('Error applying coupon', e);
      _couponError = e.toString();
      return false;
    }
  }

  // Validate coupon
  Future<bool> _validateCoupon(String couponCode) async {
    // يمكنك جلب الكوبونات من Firebase أو من API
    // هنا مثال بسيط لكوبونات تجريبية

    final validCoupons = {
      'SAVE10': {
        'discount': 10, // 10%
        'expiry': DateTime.now().add(const Duration(days: 30)),
        'minPurchase': 50.0,
      },
      'SAVE20': {
        'discount': 20, // 20%
        'expiry': DateTime.now().add(const Duration(days: 15)),
        'minPurchase': 100.0,
      },
      'WELCOME15': {
        'discount': 15, // 15%
        'expiry': DateTime.now().add(const Duration(days: 7)),
        'minPurchase': 30.0,
      },
      'FREESHIP': {
        'discount': 0, // شحن مجاني
        'expiry': DateTime.now().add(const Duration(days: 10)),
        'minPurchase': 40.0,
      },
    };

    final coupon = validCoupons[couponCode.toUpperCase()];

    if (coupon == null) {
      return false;
    }

    // التحقق من صلاحية الكوبون
    final expiry = coupon['expiry'] as DateTime;
    if (expiry.isBefore(DateTime.now())) {
      return false;
    }

    // التحقق من الحد الأدنى للشراء
    final cart = await getCart();
    final minPurchase = coupon['minPurchase'] as double;
    if (cart.subtotal < minPurchase) {
      _couponError =
          'Minimum purchase of \$${minPurchase.toStringAsFixed(2)} required';
      return false;
    }

    return true;
  }

  // Calculate discount
  Future<double> _calculateDiscount(String couponCode, double subtotal) async {
    final coupons = {
      'SAVE10': 0.10,
      'SAVE20': 0.20,
      'WELCOME15': 0.15,
      'FREESHIP': 0.0,
    };

    final discountPercent = coupons[couponCode.toUpperCase()];

    if (discountPercent == null) {
      return 0.0;
    }

    if (couponCode.toUpperCase() == 'FREESHIP') {
      // للشحن المجاني، نطبق خصم يساوي قيمة الشحن
      // يمكنك تحديد قيمة الشحن من الـ Cart
      return 10.0; // مثال: قيمة الشحن 10 دولار
    }

    double discount = subtotal * discountPercent;

    // الحد الأقصى للخصم
    const maxDiscount = 50.0;
    if (discount > maxDiscount) {
      discount = maxDiscount;
    }

    return discount;
  }

  // Remove applied coupon
  @override
  Future<bool> removeCoupon() async {
    try {
      _appliedCouponCode = null;
      _appliedCouponDiscount = null;
      await _couponRef.delete();
      _couponError = null;
      return true;
    } catch (e) {
      AppLogger.error('Error removing coupon', e);
      return false;
    }
  }

  // Get applied coupon discount
  @override
  double? getAppliedCouponDiscount() {
    return _appliedCouponDiscount;
  }

  // Get applied coupon code
  @override
  String? getAppliedCouponCode() {
    return _appliedCouponCode;
  }

  // Get coupon error message
  String? getCouponError() {
    return _couponError;
  }
}
