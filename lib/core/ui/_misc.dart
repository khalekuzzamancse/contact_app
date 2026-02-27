part of 'core_ui.dart';
extension ColorExtension on Color {
  Color get contentColor => computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
extension TextEditingControllerExtensions on TextEditingController{
  void setTextOrOriginal(String? text){
    this.text=text??this.text;
  }
}
extension SafeUpdateState on State {
  void safeSetState(void Function() updaterFunction) {
    void callSetState() {
      // Can only call setState if mounted
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(updaterFunction);
      }
    }


    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Currently building, can't call setState --
      // need to add post-frame callback
      SchedulerBinding.instance.addPostFrameCallback((_) => callSetState());
    } else {
      callSetState();
    }
  }
}
extension ContextExtension on BuildContext{
  Future<T?> push<T extends Object?>(Widget route)async{
    return await Navigator.push(this, MaterialPageRoute(builder: (_)=>route));
  }
  void pop<T extends Object?>([ T? result ]){
    return Navigator.pop(this,result);
  }
  ///In case of async-gap the context may  be invalid so can use it anywhere
  ///to prevent crash
  void popSafelyOrSkip<T extends Object?>([ T? result ]){
    if(mounted){
      Navigator.pop(this,result);
    }
  }


}

extension NavigatorExtension on Navigator{

}


class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
class LoadingUI extends StatelessWidget {
  final double size;
  final  Color? color;
  const LoadingUI({super.key,this.size=64, this.color});

  @override
  Widget build(BuildContext context) {
    return   Center(child: SizedBox(width:size,height:size,child:  CircularProgressIndicator(color: color,)));
  }
}
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  void startLoading() => _setLoading(true);

  void stopLoading() => _setLoading(false);

  void _setLoading(bool value) {
    //avoid unnecessary rebuild
    if(value==isLoading){
      return;

    }
    if (mounted) {
      safeSetState(() {
        isLoading = value;
      });
    }
  }
}


String? _currentMsg;

Future<void> showSnackBar(String? message,{String? tag,int duration=3,centralize=false})async {
  try{
    if(tag!=null){
      Logger.on('$tag::showSnackBar', '$message');
    }
    //already the same message shown
    if(_currentMsg==message){
      return;
    }
    _currentMsg=message;
    if(message==null) {
      return;
    }
    if(centralize){
      Get.dialog(
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8), // downward shadow
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        barrierColor: Colors.transparent,
      );


      Future.delayed(Duration(seconds: duration), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      });
    }
    else{
      await Get.snackbar('','',
          titleText: Text(message),
          duration: Duration(seconds: duration),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
          borderRadius: 10,
          backgroundColor: Colors.white,
          maxWidth: 300).future;
    }
    _currentMsg=null;
  }
  catch(e){
    Logger.on("ShowSnackBar", "Failed");
  }

}