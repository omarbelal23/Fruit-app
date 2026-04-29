import 'package:flutter/material.dart';
import 'package:fruit_app/features/Auth/presentation/pages/complete_information/widgets/complete_information_body.dart';

class CompleteInformationScreen extends StatelessWidget {
  const CompleteInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: CompleteInformationBody(),
    );
  }
}