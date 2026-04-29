import 'cart_item.dart';

class Cart {
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cart({
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get shippingCost => subtotal >= 50.0 ? 0.0 : 5.0;
  double get tax => subtotal * 0.1;
  double get total => subtotal + shippingCost + tax;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  // ✅ firstWhereOrNull أنظف من try/catch
  int getItemQuantity(String productId) =>
      items.cast<CartItem?>().firstWhere(
            (item) => item?.product.id == productId,
            orElse: () => null,
          )?.quantity ??
      0;

  Cart addItem(CartItem newItem) {
    final existingIndex =
        items.indexWhere((item) => item.product.id == newItem.product.id);

    if (existingIndex != -1) {
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingIndex] = updatedItems[existingIndex]
          .copyWith(quantity: updatedItems[existingIndex].quantity + newItem.quantity);
      return copyWith(items: updatedItems, updatedAt: DateTime.now());
    }

    return copyWith(items: [...items, newItem], updatedAt: DateTime.now());
  }

  Cart removeItem(String productId) {
    return copyWith(
      items: items.where((item) => item.product.id != productId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  Cart updateItemQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) return removeItem(productId);

    return copyWith(
      items: items.map((item) {
        return item.product.id == productId
            ? item.copyWith(quantity: newQuantity)
            : item;
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }

  Cart clear() => copyWith(items: [], updatedAt: DateTime.now());

  factory Cart.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return Cart(
      items: itemsJson.map((item) => CartItem.fromJson(item)).toList(),
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items
          .map((item) => {
                'product': item.product.toJson(),
                'quantity': item.quantity,
                'addedAt': item.addedAt.toIso8601String(),
              })
          .toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Cart copyWith({
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'Cart(items: ${items.length}, subtotal: $subtotal, total: $total)';
}
