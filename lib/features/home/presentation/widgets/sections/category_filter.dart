import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../product_details/controller/product_controller.dart';
import '../../../../../core/constants.dart';

class CategoryFilter extends StatelessWidget {
  final ProductController productController;

  const CategoryFilter({super.key, required this.productController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedCategory = productController.selectedCategory;
      return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: kProductCategories.length,
          itemBuilder: (context, index) {
            final category = kProductCategories[index];
            final isSelected = selectedCategory == category;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    productController.loadProductsByCategory(category);
                  }
                },
                backgroundColor: Colors.white,
                selectedColor: kMainColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : kTextColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? kMainColor : kBorderColor,
                  width: 1,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
