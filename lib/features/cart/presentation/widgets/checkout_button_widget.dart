import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../controllar/cart_controller.dart';

class CheckoutButtonWidget extends StatelessWidget {
  const CheckoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Get.find فقط
    final CartController controller = Get.find<CartController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Obx(() {
        final loading = controller.isLoading.value;
        final empty = controller.isEmpty;
        final disabled = empty || loading;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: disabled ? null : controller.goToCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: disabled ? kTextLightColor : kMainColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: disabled ? 0 : kDefaultElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              ),
            ),
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    empty ? 'Cart is Empty' : kProceedToCheckout,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
