import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../cart/presentation/controllar/cart_controller.dart';
import '../../../../../core/constants.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CartController cartController;

  const HomeAppBar({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kMainColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: kDefaultPadding),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(Icons.shopping_cart, color: Colors.white, size: 20),
          ),
        ),
      ),
      title: const Text(
        kAppName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Search Icon
        IconButton(
          onPressed: () => Get.toNamed('/search'),
          icon: const Icon(Icons.search, color: Colors.white, size: 24),
        ),
        // Cart Icon with Badge
        Stack(
          children: [
            IconButton(
              onPressed: () => Get.toNamed('/cart'),
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            Obx(() {
              final itemCount = cartController.itemCount;
              if (itemCount == 0) {
                return const SizedBox.shrink();
              }
              return Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: kAccentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kAccentColor.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          ],
        ),
        // Profile Icon
        IconButton(
          onPressed: () => Get.toNamed('/profile'),
          icon: const Icon(Icons.person_outline, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
