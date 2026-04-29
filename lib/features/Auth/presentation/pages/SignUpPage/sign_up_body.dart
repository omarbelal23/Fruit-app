import 'package:flutter/material.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/core/utils/size_config.dart';
import 'package:fruit_app/core/widgets/custom_buttons.dart';
import 'package:fruit_app/features/Auth/data/repository/auth_repo_impl.dart';
import 'package:get/get.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى تعبئة البريد الإلكتروني وكلمة المرور',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authRepo = AuthRepoImpl();
      final result = await authRepo.registerWithEmailPassword(
        email: email,
        password: password,
      );
      if (result != null) {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        'فشل التسجيل',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Text(
            'Create an account',
            style: TextStyle(
              fontSize: SizeConfig.defaultSize! * 3.0,
              fontWeight: FontWeight.bold,
              color: kMainColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start shopping fresh fruits and vegetables with a secure account.',
            style: TextStyle(
              fontSize: SizeConfig.defaultSize! * 1.6,
              color: kTextLightColor,
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomGenralButton(text: 'Sign Up', ontap: _submit),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account? '),
              TextButton(
                onPressed: () {
                  Get.offAllNamed('/login');
                },
                child: const Text('Log in'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
