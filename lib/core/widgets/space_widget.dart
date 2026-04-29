import 'package:flutter/material.dart';
import 'package:fruit_app/core/utils/size_config.dart';

class HorizentalSpace extends StatelessWidget {
  const HorizentalSpace(this.value, {super.key});
  final double value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: SizeConfig.defaultSize! * value);
  }
}

class VerticalSpace extends StatelessWidget {
  const VerticalSpace(this.value, {super.key});
  final double value;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(height: SizeConfig.defaultSize! * value);
  }
}
