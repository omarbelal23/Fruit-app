import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../../../product_details/controller/product_controller.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  // ✅ static const — مش بيتعمل كل مرة بيتبنى الـ widget
  static const _categoryMeta = <String, _CategoryMeta>{
    'all': _CategoryMeta(Icons.grid_view_rounded, kMainColor),
    'fruits': _CategoryMeta(Icons.apple_rounded, kSuccessColor),
    'vegetables': _CategoryMeta(Icons.grass_rounded, Color(0xFF388E3C)),
    'organic': _CategoryMeta(Icons.eco_rounded, kSecondaryColor),
    'seasonal': _CategoryMeta(Icons.wb_sunny_rounded, Color(0xFFF57C00)),
  };

  static _CategoryMeta _metaFor(String category) =>
      _categoryMeta[category.toLowerCase()] ??
      const _CategoryMeta(Icons.category_rounded, kMainColor);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Browse by Category',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Find your favorite fruits and vegetables',
              style: TextStyle(fontSize: 15, color: kTextLightColor),
            ),
            const SizedBox(height: 20),

            // ✅ Obx محصور بس حول الـ Grid — مش حول كل الـ Column
            Expanded(
              child: Obx(() {
                final categories = controller.categories;

                if (categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (_, index) => _CategoryCard(
                    key: ValueKey(categories[index]),
                    category: categories[index],
                    meta: _metaFor(categories[index]),
                    controller: controller,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// Extracted widget — كل card مسؤولة عن نفسها
// ────────────────────────────────────────────────
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    super.key,
    required this.category,
    required this.meta,
    required this.controller,
  });

  final String category;
  final _CategoryMeta meta;
  final ProductController controller;

  void _onTap() {
    // ✅ loadProductsByCategory بس — HomePage هي اللي بتعرض النتيجة
    // Get.toNamed بدل Get.back عشان ممكن نيجي من أي مكان
    controller.loadProductsByCategory(category);
    Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: meta.color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          border: Border.all(color: meta.color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: meta.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(meta.icon, size: 30, color: meta.color),
            ),

            const SizedBox(height: 10),

            Text(
              category,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kTextColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 3),

            // ✅ Obx منفصل لكل card — مش بيعيد بناء الـ Grid كله لما count يتغير
            Obx(() {
              final count = controller.getProductsByCategory(category).length;
              return Text(
                '$count item${count == 1 ? '' : 's'}',
                style: TextStyle(fontSize: 12, color: kTextLightColor),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// Typed model بدل Map<String, dynamic>
// ────────────────────────────────────────────────
class _CategoryMeta {
  final IconData icon;
  final Color color;

  const _CategoryMeta(this.icon, this.color);
}
