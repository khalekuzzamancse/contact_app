import 'package:contact_app/core/language/core_language.dart';
import 'package:contact_app/core/ui/core_ui.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart';

class ErrorController  {
  ErrorController._privateConstructor();
  static final ErrorController _instance = ErrorController._privateConstructor();


  static ErrorController get instance => _instance;

  late final _className = runtimeType.toString();
  var errorMsg = Rx<String?>(null);

  void updateErrorMessage(String message) {
    final alreadyTheSameMsgIsShowing = (errorMsg.value == message);
    if (alreadyTheSameMsgIsShowing) {
      return;
    }
    showSnackBar(message);
  }

  void onError(Object exception) {
    final tag = "$_className::onError()";
    Logger.on(tag, "$exception");
    if (exception is CustomException) {
      updateErrorMessage(exception.message);
    } else {
      // TODO: Handle other exceptions
    }
  }
  static void showSnackBarOrSkip(Object e) async{
    final error=toErrorMessage(e);
    if(error!=null){
      await showSnackBar(error);
    }

  }
  static  String? toErrorMessage(Object e){
    if (e is CustomException) {
      return e.message;
    }
    else if(e is ClientException){
      return 'Unable to connect server';
    }
    else {
      return 'Something is went wrong';
    }
  }


}