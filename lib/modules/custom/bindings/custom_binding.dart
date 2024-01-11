import 'package:get/get.dart';
import 'package:osm_chat/modules/custom/controllers/custom_controller.dart';

class CustomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomController>(() => CustomController());
  }
}
