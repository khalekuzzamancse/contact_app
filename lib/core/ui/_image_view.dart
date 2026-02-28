part of 'core_ui.dart';

//@formatter:off
class SvgView extends StatelessWidget {
  final String path; final double? height,width;
  final Color? color; final BoxFit? fit;
  const SvgView( this.path,{super.key,this.height, this.width, this.color, this.fit});
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        path, height: height, width: width, color: color,
        fit: fit == null ? BoxFit.contain : fit!);
  }
}