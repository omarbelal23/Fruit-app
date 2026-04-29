import 'package:flutter/material.dart';
import 'package:fruit_app/core/widgets/space_widget.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
  }) : super(key: key);
  final String imageUrl;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpace(22),
        Container(child: Image.asset(imageUrl, height: 170, fit: BoxFit.cover)),
        VerticalSpace(3),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        VerticalSpace(2.5),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
