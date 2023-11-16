import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/utils/dialogs.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  void handleNameButton() async {
    Dialogs.showProgressIndicator(context);
    await APIS.updateInfo(nameController.text, 'name').then((value) async {
      setState(() {
        APIS.me.name = nameController.text;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Dialogs.showSnackBar(context, 'Profile Updated Successfylly');
    });
  }

  void handleAboutButton() async {
    Dialogs.showProgressIndicator(context);
    await APIS.updateInfo(aboutController.text, 'about').then((value) async {
      setState(() {
        APIS.me.about = aboutController.text;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Dialogs.showSnackBar(context, 'Profile Updated Successfylly');
    });
  }

  Future<void> _refreshData() async {
    await APIS.selfInfo();
  }

  String? pickedImage;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: _refreshData,
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
                      imageModalBottomSheet();
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
                      setState(() {
                        nameController.text = APIS.me.name;
                      });
                      Dialogs.showBottomModal(
                          context, nameController, 'Name', handleNameButton);
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
                      setState(() {
                        aboutController.text = APIS.me.about;
                      });
                      Dialogs.showBottomModal(
                          context, aboutController, 'About', handleAboutButton);
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

  void imageModalBottomSheet() {
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
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            setState(() {
                              pickedImage = image.path;
                            });
                            Dialogs.showProgressIndicator(context);
                            await APIS.updateProfilePicture(File(pickedImage!));
                            setState(() {});
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            Dialogs.showSnackBar(
                                context, 'Please select image');
                          }
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
                          final ImagePicker picker = ImagePicker();
                          // Pick an image.
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (image != null) {
                            setState(() async {
                              pickedImage = image.path;
                              Dialogs.showProgressIndicator(context);
                              await APIS
                                  .updateProfilePicture(File(pickedImage!));
                              // await APIS.selfInfo();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          } else {
                            Dialogs.showSnackBar(
                                context, 'Please select image');
                          }
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

  void getCameraPermissions() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      Dialogs.showSnackBar(context, 'We Need permission to capture Image');
    }
  }

  void getGalleyPermission() async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      Dialogs.showSnackBar(context, 'We Need permission to get Images');
    }
  }

  void getmicrophonepermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      Dialogs.showSnackBar(context, 'We Need permission to record audio');
    }
  }
}
