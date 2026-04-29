import 'package:flutter/material.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/features/splash/presentation/widgets/splash_body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashBody(), backgroundColor: kMainColor);
  }
}
