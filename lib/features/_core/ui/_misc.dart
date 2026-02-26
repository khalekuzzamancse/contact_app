part of '../core_ui.dart';

final gradientDecorator = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFECFBF7),
      Colors.white,
    ],
  ),
);
class ButtonView extends StatelessWidget {
  final String label;
  final Color background, forground;
  final Color? borderColor;
  final double width;
  final VoidCallback onPressed;
  const ButtonView({super.key, required this.label, required this.background,
    required this.forground,this.width=double.infinity,required this.onPressed, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: forground
          , backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side:borderColor==null?BorderSide.none: BorderSide(color: borderColor!),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
