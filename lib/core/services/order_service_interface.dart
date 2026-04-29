import 'package:fruit_app/features/orders/data/order.dart';

abstract class OrderServiceInterface {
  /// Create a new order
  Future<String?> createOrder(Order order);

  /// Get all orders for current user
  Future<List<Order>> getUserOrders();

  /// Get order by ID
  Future<Order?> getOrderById(String orderId);

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status);

  /// Cancel order
  Future<bool> cancelOrder(String orderId);

  /// Get order stream for current user (real-time updates)
  Stream<List<Order>> getUserOrdersStream();
}
