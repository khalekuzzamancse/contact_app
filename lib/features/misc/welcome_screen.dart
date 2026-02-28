import 'package:contact_app/core/ui/core_ui.dart';
import 'package:contact_app/features/_core/core_ui.dart' hide TextView;
import 'package:contact_app/features/_core/mediator.dart';
import 'package:contact_app/features/_core/ui/_logo.dart';
import 'package:contact_app/features/contact_list/presentation/ui/contact_screen.dart';
import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    AppMediator.hideStatusBar();
  }
  @override
  void dispose() {
    AppMediator.showStatusBar();
    AppMediator.setWelcomeScreenShowed();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return   Material(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            decoration: gradientDecorator,
          ),
          Positioned.fill(
            child: Center(
              child:Logo(),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: _BottomPart())
        ],
      ),
    );
  }
}
class _BottomPart extends StatelessWidget {
  const _BottomPart({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeFactory.theme.colorPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextView('Welcome', size: 32, weight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextView(
              'Lorem ipsum dolor sit amet consectetur. Pellentesque fames lobortis vestibulum nisi nulla egestas nibh tincidunt nunc.',
                size: 14,
                color: Colors.white70
            ),
          ),
          SizedBox(height: 20),
          Container(
            constraints: BoxConstraints(
              maxWidth: 400
            ),
            child: ButtonView(
              label: 'Get Started',
              onPressed: (){
                AppMediator.setWelcomeScreenShowed();
                context.push(ContactScreen());
              },
              forground:ThemeFactory.theme.colorPrimary,
              background:Colors.white ,
            ),
          )
        ],
      ),
    );
  }
}



