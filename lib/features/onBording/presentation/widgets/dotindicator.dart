import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fruit_app/core/constants.dart';

class CustomDotIndicator extends StatelessWidget {
  const CustomDotIndicator({
    super.key,
    required this.currentPage,
    this.totalPages = 3, // ✅ بتقبل totalPages من الـ parent
  });

  final int currentPage; // ✅ int بدل double? — أنظف وبيتوافق مع الـ parent
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: totalPages,
      position: currentPage.toDouble(), // ✅ تحويل int إلى double
      decorator: DotsDecorator(
        size: const Size(10, 10),
        activeSize: const Size(24, 10), // ✅ الـ active dot أعرض — أجمل وأوضح
        color: kMainColor.withValues(alpha: 0.25),
        activeColor: kMainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: kMainColor.withValues(alpha: 0.4)),
        ),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // ✅ pill shape للـ active
        ),
      ),
    );
  }
}