import 'package:flutter/material.dart';
import 'package:fruit_app/core/services/cart_service.dart';
import 'package:fruit_app/core/services/cart_service_interface.dart';
import 'package:fruit_app/core/services/product_service.dart';
import 'package:fruit_app/features/orders/presentation/pages/order_history_page.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// Pages
import 'package:fruit_app/features/Auth/presentation/pages/LoginPage/login_page_screen.dart';
import 'package:fruit_app/features/Auth/presentation/pages/SignUpPage/sign_up_page_screen.dart';
import 'package:fruit_app/features/Auth/presentation/pages/auth_gate/auth_gate.dart';
import 'package:fruit_app/features/cart/presentation/cart_page.dart';
import 'package:fruit_app/features/checkout/presentation/pages/checkout_page.dart';
import 'package:fruit_app/features/home/presentation/pages/home_page.dart';
import 'package:fruit_app/features/categories/presentation/page/categories_page.dart';
import 'package:fruit_app/features/favorites/presentation/page/favorites_page.dart';
import 'package:fruit_app/features/onBording/presentation/onbording_screen.dart';
import 'package:fruit_app/features/profile/presentation/page/profile_page.dart';
import 'package:fruit_app/features/search/presentation/page/search_page.dart';
import 'package:fruit_app/features/product_details/presentation/product_details_page.dart';
import 'package:fruit_app/features/splash/presentation/splash_screen.dart';

// Controllers
import 'package:fruit_app/features/product_details/controller/product_controller.dart';
import 'package:fruit_app/features/cart/presentation/controllar/cart_controller.dart';

// Services
import 'package:fruit_app/core/services/product_service_interface.dart';
import 'package:fruit_app/core/services/order_service.dart';
import 'package:fruit_app/core/services/order_service_interface.dart';

void setupDependencies() {
  // ✅ 1. Services الأول دايماً — قبل أي controller
  Get.put<ProductServiceInterface>(ProductService(), permanent: true);
  Get.put<CartServiceInterface>(CartService(), permanent: true);
  Get.put<OrderServiceInterface>(OrderService(), permanent: true);

  // ✅ 2. Controllers بعد الـ services — permanent عشان ميتمسحوش
  Get.put<ProductController>(ProductController(), permanent: true);
  Get.put<CartController>(CartController(), permanent: true);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ setupDependencies قبل addSampleProducts
  setupDependencies();

  final productService = Get.find<ProductServiceInterface>();
  await (productService as ProductService).addSampleProducts();

  runApp(const FruitMarket());
}

class FruitMarket extends StatelessWidget {
  const FruitMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      title: 'Fruit Market',
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/orders', page: () => const OrderHistoryPage()),
        GetPage(name: '/onboarding', page: () => const OnBordingScreen()),
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/', page: () => const AuthGate()),
        GetPage(name: '/login', page: () => const LoginPageScreen()),
        GetPage(name: '/signup', page: () => const SignUpPageScreen()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/cart', page: () => const CartPage()),
        GetPage(name: '/checkout', page: () => CheckoutPage()),
        GetPage(name: '/product/:id', page: () => const ProductDetailsPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/categories', page: () => const CategoriesPage()),
        GetPage(name: '/favorites', page: () => const FavoritesPage()),
        GetPage(name: '/search', page: () => const SearchPage()),
      ],
    );
  }
}
