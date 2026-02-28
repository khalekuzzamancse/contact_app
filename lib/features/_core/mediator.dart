import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMediator {
  static final _keyOnBoarded = 'onboarded';

 static Future<bool> isWelcomeScreenShowed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyOnBoarded) ?? false;
    } catch (_) {
      return false;
    }
  }
 static Future<void> setWelcomeScreenShowed() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyOnBoarded, true);

}
 static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
 static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }
}
