import 'package:flutter/material.dart';
import 'package:fruit_app/core/widgets/custom_buttons.dart'
    show CustomGenralButton;
import 'package:fruit_app/core/widgets/space_widget.dart';
import 'package:fruit_app/features/Auth/data/repository/auth_repo_impl.dart';
import 'package:fruit_app/features/Auth/presentation/pages/complete_information/widgets/complete_info_item.dart';

class CompleteInformationBody extends StatelessWidget {
  CompleteInformationBody({Key? key}) : super(key: key);
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          VerticalSpace(10),
          CompleteInfoItem(text: 'Enter your name', controller: nameController),
          VerticalSpace(2),
          CompleteInfoItem(
            text: 'Enter your phone number',
            controller: phoneController,
          ),
          VerticalSpace(2),
          CompleteInfoItem(
            maxLines: 5,
            text: 'Enter your address',
            controller: addressController,
          ),
          VerticalSpace(5),
          CustomGenralButton(
            text: 'Login',
            ontap: () async {
              final authRepo = AuthRepoImpl();

              await authRepo.completeInformation(
                name: nameController.text,
                phoneNumber: phoneController.text,
                address: addressController.text,
              );

              // بعد ما البيانات تتحفظ، نروح للـ HomePage
              Navigator.pushReplacementNamed(context, '/');
              // أو باستخدام GetX:
              // Get.offAllNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
