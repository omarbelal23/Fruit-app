import 'package:flutter/material.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/core/services/order_service_interface.dart';
import 'package:fruit_app/features/cart/presentation/controllar/cart_controller.dart';
import 'package:fruit_app/features/orders/data/order.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:uuid/uuid.dart';

class PlaceOrderButtonWidget extends StatefulWidget {
  const PlaceOrderButtonWidget({super.key});

  @override
  State<PlaceOrderButtonWidget> createState() => _PlaceOrderButtonWidgetState();
}

class _PlaceOrderButtonWidgetState extends State<PlaceOrderButtonWidget> {
  bool isLoading = false;

  final CartController cartController = Get.find<CartController>();
  final OrderServiceInterface orderService = Get.find<OrderServiceInterface>();

  void _placeOrder() async {
    if (cartController.isEmpty) return;

    Get.defaultDialog(
      title: "Confirm Order",
      middleText: "Are you sure you want to place the order?",
      textConfirm: "Yes",
      textCancel: "No",
      onConfirm: () async {
        Get.back();

        setState(() => isLoading = true);

        try {
          // Get delivery address and phone from cart controller or user preferences
          // TODO: Get these from form fields in checkout page
          final deliveryAddress = "Your Address Here";
          final phoneNumber = "Your Phone Here";
          final paymentMethod = "card";

          // Create order object
          final order = Order(
            id: const Uuid().v4(),
            userId: '', // Will be set by OrderService
            items: cartController.cart.items,
            totalAmount: cartController.total,
            appliedDiscount: null,
            couponCode: null,
            deliveryAddress: deliveryAddress,
            phoneNumber: phoneNumber,
            paymentMethod: paymentMethod,
            status: OrderStatus.pending,
            createdAt: DateTime.now(),
          );

          // Save order to Firestore
          final orderId = await orderService.createOrder(order);

          if (orderId != null) {
            setState(() => isLoading = false);

            Get.snackbar(
              "Success",
              "Order placed successfully 🎉",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );

            // Clear cart after successful order
            await cartController.clearCart();

            // Navigate to home
            Get.offAllNamed('/home');
          } else {
            setState(() => isLoading = false);
            Get.snackbar(
              "Error",
              "Failed to place order. Please try again.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } catch (e) {
          setState(() => isLoading = false);
          Get.snackbar(
            "Error",
            "An error occurred: ${e.toString()}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : _placeOrder,
      style: ElevatedButton.styleFrom(
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Place Order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}
