import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_app/features/cart/presentation/data/cart_item.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final double? appliedDiscount;
  final String? couponCode;
  final String deliveryAddress;
  final String phoneNumber;
  final String paymentMethod; // 'card', 'cash', 'wallet'
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? deliveryNotes;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.appliedDiscount,
    this.couponCode,
    required this.deliveryAddress,
    required this.phoneNumber,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.deliveredAt,
    this.deliveryNotes,
  });

  // ✅ FIX 1: DateTime → toIso8601String() عشان Firestore يحفظها صح
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'appliedDiscount': appliedDiscount,
      'couponCode': couponCode,
      'deliveryAddress': deliveryAddress,
      'phoneNumber': phoneNumber,
      'paymentMethod': paymentMethod,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(), // ✅ كان DateTime object
      'deliveredAt': deliveredAt?.toIso8601String(), // ✅ كان DateTime object
      'deliveryNotes': deliveryNotes,
    };
  }

  // ✅ FIX 2: handle Firestore Timestamp + String + DateTime الثلاثة
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      appliedDiscount: (json['appliedDiscount'] as num?)?.toDouble(),
      couponCode: json['couponCode'],
      deliveryAddress: json['deliveryAddress'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'card',

      // ✅ FIX 3: safe status parse — مش بيـ throw لو القيمة غريبة
      status: _parseStatus(json['status']),

      // ✅ FIX 4: handle Timestamp (Firestore) + String + DateTime
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      deliveredAt: _parseDateTime(json['deliveredAt']),
      deliveryNotes: json['deliveryNotes'],
    );
  }

  // ✅ helper — بيتعامل مع Firestore Timestamp, String, DateTime, null
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate(); // ✅ Firestore Timestamp
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value); // ✅ ISO string
    }
    return null;
  }

  // ✅ helper — fallback لـ pending لو الـ status جه غلط أو null
  static OrderStatus _parseStatus(dynamic value) {
    if (value == null) return OrderStatus.pending;
    try {
      return OrderStatus.values.byName(value.toString());
    } catch (_) {
      return OrderStatus.pending; // ✅ بدل ما يـ throw
    }
  }

  Order copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? totalAmount,
    double? appliedDiscount,
    String? couponCode,
    String? deliveryAddress,
    String? phoneNumber,
    String? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? deliveredAt,
    String? deliveryNotes,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      appliedDiscount: appliedDiscount ?? this.appliedDiscount,
      couponCode: couponCode ?? this.couponCode,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
    );
  }

  @override
  String toString() =>
      'Order(id: $id, status: ${status.name}, total: $totalAmount)';
}
