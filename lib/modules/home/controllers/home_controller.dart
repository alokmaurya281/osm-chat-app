import 'package:google_sign_in/google_sign_in.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/modules/custom/controllers/custom_controller.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class HomeController extends CustomController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<void> signout() async {
    ZegoUIKitPrebuiltCallInvitationService().uninit();
    // Dialogs.showProgressIndicator(context);
    await APIS.updateActiveStatus(false);
    await APIS.auth.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value) async {
        // Navigator.pop(context);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) {
        //   return const LoginScreen();
        // }));
      });
    });
    // ignore: use_build_context_synchronously
  }

  List<ChatUser> list = [];
  final List<ChatUser> searchList = [];

  bool isSearching = false;

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  
}