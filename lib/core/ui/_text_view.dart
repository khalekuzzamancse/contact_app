part of 'core_ui.dart';
///The core raw text view
class TextView extends StatelessWidget {
  final String text; final Color? color;
  final String? family; final double? size;
  final FontWeight? weight;
  const TextView(this.text,{super.key,this.color, this.family,this.size,this.weight});
  @override
  Widget build(BuildContext context) {
    return Text(text,style:
    TextStyle(color: color,fontFamily: family,fontSize: size,fontWeight: weight));
  }
}
