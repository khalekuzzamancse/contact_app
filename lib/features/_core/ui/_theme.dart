part of '../core_ui.dart';
/// The abstract factory
abstract class ThemeFactory{
  Color get colorPrimary;
  Color get colorSecondary;
  Color get colorTextH2;
  final  String font ='Inter';
  static  ThemeFactory theme=_LightTheme();
  static void setMode({final bool isLightMode=true}){
    if(isLightMode){
      theme=_LightTheme();
    }
    else{}
  }
}

class _LightTheme extends ThemeFactory{
  @override
  Color get colorPrimary => Color(0xFF098268);
  @override
  Color get colorSecondary => Colors.white;

  @override
  Color get colorTextH2 => throw UnimplementedError();
}
