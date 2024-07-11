// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/modules/profile/controllers/profile_controller.dart';
import 'package:osm_chat/utils/dialogs.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () {
        return controller.refreshData();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(239, 11, 116, 182),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(100)),
                    child: CircleAvatar(
                      // backgroundImage: C
                      backgroundImage: CachedNetworkImageProvider(
                        APIS.me.image,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 125,
                  child: GestureDetector(
                    onTap: () {
                      imageModalBottomSheet(context);
                    },
                    child: Icon(
                      Icons.camera_enhance,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.person,
                    size: 24,
                  ),
                  SizedBox(
                    width: 200,
                    // height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          APIS.me.name,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.nameController.text = APIS.me.name;
                      Dialogs.showBottomModal(
                        context,
                        controller.nameController,
                        'Name',
                        handleNameButton,
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.description,
                    size: 24,
                  ),
                  SizedBox(
                    width: 200,
                    // height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          APIS.me.about,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.aboutController.text = APIS.me.about;
                      // print(controller.aboutController.text);
                      Dialogs.showBottomModal(
                        context,
                        controller.aboutController,
                        'About',
                        handleAboutButton,
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleNameButton(BuildContext context) async {
    Dialogs.showProgressIndicator(context);
    await APIS
        .updateInfo(controller.nameController.text, 'name')
        .then((value) async {
      APIS.me.name = controller.nameController.text;
      Navigator.pop(context);
      Navigator.pop(context);
      Dialogs.showSnackBar(context, 'Profile Updated Successfully');
    });
  }

  void handleAboutButton(BuildContext context) {
    Dialogs.showProgressIndicator(context);
    APIS
        .updateInfo(controller.aboutController.text, 'about')
        .then((value) async {
      APIS.me.about = controller.aboutController.text;
      Navigator.pop(context);
      Navigator.pop(context);
      Dialogs.showSnackBar(context, 'Profile Updated Successfully');
    });
  }

  void imageModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(255, 39, 58, 118),
        context: context,
        builder: (context) {
          return SizedBox(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                children: [
                  Text(
                    'Choose Image',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          fixedSize: const Size(80, 80),
                        ),
                        onPressed: () async {
                          await controller.pickImage(context);
                        },
                        child: Image.asset(
                          'assets/icons/gallery.png',
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          fixedSize: const Size(80, 80),
                        ),
                        onPressed: () async {
                          await controller.pickCameraImage(context);
                        },
                        child: Image.asset(
                          'assets/icons/camera.png',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getCameraPermissions(BuildContext context) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      Dialogs.showSnackBar(context, 'We Need permission to capture Image');
    }
  }

  void getGalleyPermission(BuildContext context) async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      Dialogs.showSnackBar(context, 'We Need permission to get Images');
    }
  }

  void getmicrophonepermission(BuildContext context) async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      Dialogs.showSnackBar(context, 'We Need permission to record audio');
    }
  }
}
