part of '../core_ui.dart';

class TextBodySmall extends StatelessWidget {
  final String text; final Color? color;
  final double? size,letterspace;
  final FontWeight? weight;
  const TextBodySmall(this.text,{super.key,this.color,this.size=14,this.weight=FontWeight.w400,this.letterspace});
  @override
  Widget build(BuildContext context) {
    return TextView(text,color: color,fontSize: size,weight: weight,letterSpace: letterspace,);
  }
}
///The core text view for feature layer
/// has some default value
class TextView extends StatelessWidget {
  final String text; final Color? color;
  final double? fontSize,letterSpace;
  final FontWeight? weight;
  final TextOverflow? overflow;
  const TextView(this.text,{super.key,this.color,this.fontSize,this.weight,this.letterSpace,
   this.overflow});
  @override
  Widget build(BuildContext context) {
    return Text(text,style:
    TextStyle(
      overflow: overflow,
      color: color,fontFamily: ThemeFactory.theme.font,
        fontSize: fontSize,fontWeight: weight,
      letterSpacing: letterSpace,
    ));
  }
}