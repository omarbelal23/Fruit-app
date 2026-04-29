import 'package:flutter/material.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/core/utils/size_config.dart';
import 'package:fruit_app/core/widgets/custom_buttons.dart';
import 'package:fruit_app/core/widgets/space_widget.dart';
import 'package:fruit_app/features/Auth/data/repository/auth_repo_impl.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart'
    show GetNavigation;

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        VerticalSpace(10),
        SizedBox(
          child: Image.asset(kLogo),
          height: SizeConfig.defaultSize! * 17,
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 51,
              color: const Color(0xff69a03a),
            ),
            children: [
              TextSpan(
                text: 'F',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: 'ruit Market',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: false,
          ),
          textAlign: TextAlign.left,
        ),
        Expanded(child: SizedBox()),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomButtonWithIcon(
                  onTap: () async {
                    final authRepo = AuthRepoImpl();

                    final result = await authRepo.loginWithGoogle();

                    if (result != null) {
                      Get.offAllNamed('/'); // يروح للـ AuthGate
                    }
                  },
                  color: const Color(0xFFdb3236),
                  iconData: Icons.g_mobiledata,
                  text: 'Log in with ',
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomButtonWithIcon(
                  onTap: () async {
                    final authRepo = AuthRepoImpl();

                    final result = await authRepo.loginWithFacebook();

                    if (result != null) {
                      Get.offAllNamed('/'); // يروح للـ AuthGate
                    }
                  },
                  color: const Color(0xFF4267B2),
                  iconData: Icons.facebook,
                  text: 'Log in with ',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don\'t have an account? '),
            TextButton(
              onPressed: () {
                Get.toNamed('/signup');
              },
              child: const Text('Sign up'),
            ),
          ],
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
