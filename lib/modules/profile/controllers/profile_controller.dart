import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/modules/custom/controllers/custom_controller.dart';
import 'package:osm_chat/utils/dialogs.dart';

class ProfileController extends CustomController {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  RxString pickedImage = ''.obs;

  Future<void> refreshData() async {
    await APIS.selfInfo();
  }



  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      pickedImage = image.path.obs;
      Dialogs.showProgressIndicator(context);
      await APIS.updateProfilePicture(File(pickedImage.value));
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Dialogs.showSnackBar(context, 'Please select image');
    }
  }

  Future<void> pickCameraImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      pickedImage = image.path.obs;
      Dialogs.showProgressIndicator(context);
      await APIS.updateProfilePicture(File(pickedImage!.value));
      // await APIS.selfInfo();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Dialogs.showSnackBar(context, 'Please select image');
    }
  }
}
