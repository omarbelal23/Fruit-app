import 'package:flutter/material.dart';
import 'package:fruit_app/core/utils/size_config.dart';
import 'package:fruit_app/core/widgets/custom_buttons.dart';
import 'package:fruit_app/features/onBording/presentation/page_view_screen.dart';
import 'package:fruit_app/features/onBording/presentation/widgets/dotindicator.dart';
import 'package:get/get.dart';

class OnBordingScreenBody extends StatefulWidget {
  const OnBordingScreenBody({super.key});

  @override
  State<OnBordingScreenBody> createState() => _OnBordingScreenBodyState();
}

class _OnBordingScreenBodyState extends State<OnBordingScreenBody> {
  static const int _totalPages = 3;

  late final PageController _pageController;
  int _currentPage = 0;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() => _currentPage = page);
    }
  }

  void _navigateToHome() {
    if (_isNavigating) return;
    _isNavigating = true;

    // ✅ الـ controllers اتسجلوا بالفعل في setupDependencies في main.dart
    // مش محتاج نسجل أي حاجة هنا — بس روح على طول
    Get.offAllNamed('/home');
  }

  void _goToNext() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  bool get _isLastPage => _currentPage == _totalPages - 1;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Stack(
        children: [
          PageViewScreen(pageController: _pageController),

          /// Skip
          if (!_isLastPage)
            Positioned(
              top: SizeConfig.screenHeight! * .07,
              right: SizeConfig.screenWidth! * .06,
              child: GestureDetector(
                onTap: _navigateToHome,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: SizeConfig.defaultSize! * 2.0,
                    color: const Color(0xFF898989),
                  ),
                ),
              ),
            ),

          /// Dots
          Positioned(
            bottom: SizeConfig.defaultSize! * 32,
            left: 0,
            right: 0,
            child: CustomDotIndicator(
              currentPage: _currentPage,
              totalPages: _totalPages,
            ),
          ),

          /// Button
          Positioned(
            bottom: SizeConfig.screenHeight! * .2,
            left: SizeConfig.screenWidth! * .3,
            right: SizeConfig.screenWidth! * .3,
            child: CustomGenralButton(
              ontap: _goToNext,
              text: _isLastPage ? 'Get Started' : 'Next',
            ),
          ),
        ],
      ),
    );
  }
}
