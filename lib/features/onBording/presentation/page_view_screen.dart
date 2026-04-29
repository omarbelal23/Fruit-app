import 'package:flutter/material.dart';
import 'package:fruit_app/features/onBording/presentation/widgets/page_view_body.dart';

class PageViewScreen extends StatelessWidget {
   PageViewScreen({super.key, required this.pageController});
final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return CustomPageView(pageController: pageController);
  }
}
