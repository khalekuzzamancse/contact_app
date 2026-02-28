import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'features/_core/mediator.dart';
import 'features/contact_list/presentation/ui/contact_screen.dart';
import 'features/misc/splash_screen.dart';
import 'features/misc/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var showSplash=true;
  var onboarded=false;
  @override
  void initState() {
    AppMediator.hideStatusBar();
    super.initState();
    init();
  }
  void init()async{
    final onboarded=await AppMediator.isWelcomeScreenShowed();
     await Future.delayed(Duration(seconds: 5),(){
      setState(() {
        showSplash=false;
        this.onboarded=onboarded;
      });
      AppMediator.showStatusBar();
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home: showSplash?SplashScreen():(onboarded?Scaffold(body: ContactScreen()):WelcomeScreen()),);
  }

}



