import 'package:flutter/material.dart';
import 'package:fruit_app/features/onBording/presentation/widgets/page_view_item.dart';

// ✅ static const — البيانات ثابتة ومش محتاجة تتعمل كل build
class CustomPageView extends StatelessWidget {
  const CustomPageView({super.key, required this.pageController});

  final PageController pageController;

  static const _pages = <_PageData>[
    _PageData(
      imageUrl: 'assets/images/onboarding1.png',
      title: 'Welcome to our app',
      description: 'Discover the best fruits and enjoy a healthy lifestyle with us.',
    ),
    _PageData(
      imageUrl: 'assets/images/onboarding2.png',
      title: 'Delivery on the way',
      description:
          'Get your favorite fruits delivered to your doorstep quickly and conveniently.',
    ),
    _PageData(
      imageUrl: 'assets/images/onboarding3.png',
      title: 'Delivery arrived',
      description:
          'Order your favorite fruits and have them delivered to your doorstep in no time.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: _pages.length,
      itemBuilder: (_, index) => PageViewItem(
        imageUrl: _pages[index].imageUrl,
        title: _pages[index].title,
        description: _pages[index].description,
      ),
    );
  }
}

class _PageData {
  final String imageUrl;
  final String title;
  final String description;

  const _PageData({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}