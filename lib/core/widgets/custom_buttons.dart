import 'package:flutter/material.dart';
import 'package:fruit_app/core/constants.dart';
import 'package:fruit_app/core/utils/size_config.dart';
import 'package:fruit_app/core/widgets/space_widget.dart';

class CustomGenralButton extends StatelessWidget {
  const CustomGenralButton({super.key, this.text, this.ontap});
  final String? text;
  final VoidCallback? ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 60,
        width: SizeConfig.screenWidth! * .5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kMainColor,
        ),
        child: Center(
          child: Text(
            text ?? 'Button',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.defaultSize! * 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonWithIcon extends StatelessWidget {
  const CustomButtonWithIcon({
    super.key,
    required this.text,
    this.onTap,
    this.iconData,
    this.color,
  });
  final String text;
  final IconData? iconData;
  final VoidCallback? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF707070)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData!, color: color),
            HorizentalSpace(2),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 12,
                color: const Color(0xff000000),
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
