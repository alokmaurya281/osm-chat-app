import 'package:get/get.dart';
import 'package:osm_chat/modules/auth/signup/controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
