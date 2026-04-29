import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/core/utils/logger.dart';
import 'package:fruit_app/features/orders/data/order.dart' as order_model;
import 'order_service_interface.dart';

class OrderService implements OrderServiceInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  @override
  Future<String?> createOrder(order_model.Order order) async {
    try {
      if (_userId == null) {
        throw Exception('User not authenticated');
      }

      // Generate order ID
      final docRef = _firestore
          .collection(kUsersCollection)
          .doc(_userId)
          .collection('orders')
          .doc();

      final orderId = docRef.id;
      final orderData = order.copyWith(id: orderId, userId: _userId!);

      await docRef.set(orderData.toJson());

      AppLogger.info('Order created successfully: $orderId');
      return orderId;
    } catch (e) {
      AppLogger.error('Error creating order', e);
      return null;
    }
  }

  @override
  Future<List<order_model.Order>> getUserOrders() async {
    try {
      if (_userId == null) {
        return [];
      }

      final querySnapshot = await _firestore
          .collection(kUsersCollection)
          .doc(_userId)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final orderData = Map<String, dynamic>.from(data);
        return order_model.Order.fromJson(orderData);
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting user orders', e);
      return [];
    }
  }

  @override
  Future<order_model.Order?> getOrderById(String orderId) async {
    try {
      if (_userId == null) {
        return null;
      }

      final doc = await _firestore
          .collection(kUsersCollection)
          .doc(_userId)
          .collection('orders')
          .doc(orderId)
          .get();

      if (doc.exists && doc.data() != null) {
        return order_model.Order.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting order by ID', e);
      return null;
    }
  }

  @override
  Future<bool> updateOrderStatus(
    String orderId,
    order_model.OrderStatus status,
  ) async {
    try {
      if (_userId == null) {
        return false;
      }

      await _firestore
          .collection(kUsersCollection)
          .doc(_userId)
          .collection('orders')
          .doc(orderId)
          .update({
            'status': status.name,
            'deliveredAt': status == order_model.OrderStatus.delivered
                ? DateTime.now()
                : null,
          });

      AppLogger.info('Order status updated: $orderId - ${status.name}');
      return true;
    } catch (e) {
      AppLogger.error('Error updating order status', e);
      return false;
    }
  }

  @override
  Future<bool> cancelOrder(String orderId) async {
    try {
      if (_userId == null) {
        return false;
      }

      final order = await getOrderById(orderId);
      if (order == null) {
        return false;
      }

      // Only allow cancellation if order is pending
      if (order.status != order_model.OrderStatus.pending) {
        throw Exception(
          'Cannot cancel order with status: ${order.status.name}',
        );
      }

      await _firestore
          .collection(kUsersCollection)
          .doc(_userId)
          .collection('orders')
          .doc(orderId)
          .update({'status': order_model.OrderStatus.cancelled.name});

      AppLogger.info('Order cancelled: $orderId');
      return true;
    } catch (e) {
      AppLogger.error('Error cancelling order', e);
      return false;
    }
  }

  @override
  Stream<List<order_model.Order>> getUserOrdersStream() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(kUsersCollection)
        .doc(_userId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            final data = doc.data();
            return order_model.Order.fromJson(data);
          }).toList();
        });
  }
}
