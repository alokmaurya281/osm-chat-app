// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/modules/custom/controllers/custom_controller.dart';
import 'package:osm_chat/routes/app_routes.dart';
import 'package:osm_chat/utils/dialogs.dart';

class HomeController extends CustomController {
  @override
  void onInit() {
    me();
    super.onInit();
  }

  void me() {
    APIS.selfInfo();
    // getPermissions();
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (APIS.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          await APIS.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          await APIS.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  List<ChatUser> list = [];
   List<ChatUser> searchList = [];

  RxBool isSearching = false.obs;

  void changeSearchMode() {
    isSearching.value = !isSearching.value;
    update();
  }

  void search(value) {
    searchList.clear();
    update(); // Clear the previous search results
    for (var element in list) {
      if (element.name.toLowerCase().contains(value.toLowerCase()) ||
          element.email.toLowerCase().contains(value.toLowerCase())) {
        if (!searchList.contains(element)) {
          searchList.add(element);
          update();
        }
      }
    }
  }

  Future<void> signout(BuildContext context) async {
    // ZegoUIKitPrebuiltCallInvitationService().uninit();
    Dialogs.showProgressIndicator(context);
    await APIS.updateActiveStatus(false);
    await APIS.auth.signOut().then((value) async {
      log('tru');
      await GoogleSignIn().signOut().then((value) async {
        Get.offNamed(AppRoutes.login);
      });
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
