import 'package:flutter/material.dart';
import 'package:fruit_app/features/Auth/presentation/pages/SignUpPage/sign_up_body.dart';

class SignUpPageScreen extends StatelessWidget {
  const SignUpPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color(0xFF69A03A),
      ),
      body: const SafeArea(child: SignUpBody()),
    );
  }
}
