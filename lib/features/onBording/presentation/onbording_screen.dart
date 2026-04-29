import 'package:flutter/material.dart';
import 'package:fruit_app/features/onBording/presentation/widgets/onbording_screen_body.dart';

class OnBordingScreen extends StatelessWidget {
  const OnBordingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OnBordingScreenBody());
  }
}
