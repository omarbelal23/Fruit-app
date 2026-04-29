import '../../../product_details/data/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    required this.product,
    this.quantity = 1,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  // ✅ منطق صح — السعر المخفض أقل من الأصلي
  double get totalPriceWithDiscount {
    final effectivePrice = product.hasDiscount
        ? product.price
        : (product.originalPrice ?? product.price);
    return effectivePrice * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
      addedAt: DateTime.parse(
        json['addedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  CartItem copyWith({Product? product, int? quantity, DateTime? addedAt}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  CartItem increaseQuantity() => copyWith(quantity: quantity + 1);

  CartItem decreaseQuantity() {
    if (quantity > 1) return copyWith(quantity: quantity - 1);
    return this;
  }

  @override
  String toString() =>
      'CartItem(product: ${product.name}, quantity: $quantity, total: $totalPrice)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem && other.product.id == product.id);

  @override
  int get hashCode => product.id.hashCode;
}
