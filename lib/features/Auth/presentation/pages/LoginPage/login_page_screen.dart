import 'package:flutter/material.dart';
import 'package:fruit_app/features/Auth/presentation/pages/LoginPage/widgets/login_body.dart';

class LoginPageScreen extends StatelessWidget {
  const LoginPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginBody());
  }
}
