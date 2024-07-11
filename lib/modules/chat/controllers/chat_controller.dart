import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/models/message_model.dart';
import 'package:osm_chat/modules/custom/controllers/custom_controller.dart';

class ChatController extends CustomController {
  IconData _iconData = Icons.mic;
  RxString pickedImage = ''.obs;
  final TextEditingController messageController = TextEditingController();
  List<Message> list = [];
  RxBool showEmoji = false.obs;
  ChatUser user = Get.arguments;

  void changeShowEmoji() {
    showEmoji.value = !showEmoji.value;
  }

  IconData get iconData => _iconData;

  void setIcon(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      _iconData = Icons.send;
      update();
    } else {
      _iconData = Icons.mic;
      update();
    }
  }
}
