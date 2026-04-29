import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/features/product_details/controller/product_controller.dart';

import '../widgets/home_botton_nav/home_bottom_nav_bar.dart';
import '../widgets/product_card/product_card.dart';

import 'package:fruit_app/features/categories/presentation/page/categories_page.dart';
import 'package:fruit_app/features/favorites/presentation/page/favorites_page.dart';
import 'package:fruit_app/features/profile/presentation/page/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Get.find فقط — مش Get.put، لأن AppBinding سجلهم قبل كده
    final controller = Get.find<ProductController>();
    return _HomeView(controller: controller);
  }
}

class _HomeView extends StatefulWidget {
  final ProductController controller;

  const _HomeView({required this.controller});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeContent(controller: widget.controller),
      const CategoriesPage(),
      const FavoritesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(kAppName),
        backgroundColor: kMainColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/search'),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => Get.toNamed('/cart'),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final ProductController controller;

  const _HomeContent({required this.controller});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fresh fruits and vegetables',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore our fresh selection and place your order.',
            style: TextStyle(fontSize: 16, color: kTextLightColor),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (widget.controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
                  ),
                );
              }

              final products = widget.controller.products;

              if (products.isEmpty) {
                return const Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(fontSize: 16, color: kTextLightColor),
                  ),
                );
              }

              return GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    key: ValueKey(product.id),
                    product: product,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
