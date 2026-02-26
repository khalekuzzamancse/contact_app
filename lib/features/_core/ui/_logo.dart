import 'package:contact_app/core/ui/core_ui.dart';
import 'package:contact_app/features/_core/core_ui.dart';
import 'package:contact_app/features/_core/ui/_image_factory.dart';
import 'package:flutter/material.dart';
class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgView(ImageFactory.logo, width: 171, height: 168),
        SpacerVertical(8),
        TextBodySmall('Make Life Easy',color: Color(0xFF717171),letterspace: 3,),
      ],
    );
  }
}
