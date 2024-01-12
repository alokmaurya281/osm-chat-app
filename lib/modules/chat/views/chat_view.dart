import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/models/message_model.dart';
import 'package:osm_chat/modules/chat/controllers/chat_controller.dart';
import 'package:osm_chat/utils/dialogs.dart';
import 'package:osm_chat/utils/my_date_util.dart';
import 'package:osm_chat/widgets/message_card.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zpns/zego_zpns.dart';

// ignore: must_be_immutable

class ChatView extends GetView<ChatController> {
  // final Chatcontroller.controller.user controller.controller.user;

  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // print(controller.controller.user.name);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () {
          if (controller.showEmoji.value) {
            controller.changeShowEmoji();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIS.getallMessages(controller.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: SizedBox(),
                        );

                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text('Say Hii 👋 '),
                          );
                        }
                        final data = snapshot.data?.docs;
                        controller.list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (controller.list.isEmpty) {
                          return Center(
                            child: Text(
                              'Say Hii 👋 ',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 22,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.only(top: 8),
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.list.length,
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: controller.list[index],
                              );
                            },
                          );
                        }
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _chatInputField(context, controller.messageController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatInputField(
      BuildContext context, TextEditingController messageController) {
    return Row(
      children: [
        const SizedBox(
          width: 2,
        ),
        Expanded(
          child: SizedBox(
            // height: 65,
            child: Card(
              color: const Color.fromARGB(108, 187, 231, 255),
              child: TextFormField(
                onChanged: (value) {
                  controller.setIcon(messageController);
                },
                controller: messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                decoration: InputDecoration(
                  hintText: 'Enter Message...',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      mediaModalBottomSheet();
                    },
                    child: const Icon(
                      Icons.attach_file,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 21, 107, 37),
            ),
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                if (controller.list.isEmpty) {
                  APIS.sendFirstMessage(
                      controller.user, messageController.text, 'text');
                  messageController.text;
                  messageController.clear();
                } else {
                  APIS.sendMessage(
                      controller.user, messageController.text, 'text');
                  messageController.text;
                  messageController.clear();
                }
              } else {
                Dialogs.showSnackBar(context, "Enter Message");
              }
            },
            icon: Icon(
              controller.iconData,
              size: 24,
            ),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
      ],
    );
  }

  void mediaModalBottomSheet() {
    var context;
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
                    'Choose Media',
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
                          final List<XFile> medias =
                              await picker.pickMultipleMedia();
                          Dialogs.showProgressIndicator(context);
                          Navigator.pop(context);

                          for (var element in medias) {
                            // setState(() {
                            controller.pickedImage.value = element.path;
                            // });
                            await APIS.sendChatMedia(
                                controller.user,
                                File(controller.pickedImage.value!),
                                'document');
                          }
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/icons/document.png',
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
                          final List<String> imageMimeTypes = [
                            'jpeg',
                            'png',
                            'gif',
                            'bmp',
                            'webp',
                            'jpg',
                          ];

                          final List<String> videoMimeTypes = [
                            'mpeg',
                            'mp4',
                            'webm',
                            'ogg',
                            'quicktime',
                          ];
                          // Pick an image.
                          final List<XFile> medias =
                              await picker.pickMultipleMedia();
                          Dialogs.showProgressIndicator(context);
                          Navigator.pop(context);

                          for (var element in medias) {
                            final ext = element.name.split('.').last;

                            // setState(() {
                            controller.pickedImage.value = element.path;
                            // print('${element.name} Hiii');
                            // });

                            if (imageMimeTypes.contains(ext)) {
                              await APIS.sendChatMedia(controller.user,
                                  File(controller.pickedImage.value!), 'image');
                            } else if (videoMimeTypes.contains(ext)) {
                              await APIS.sendChatMedia(controller.user,
                                  File(controller.pickedImage.value!), 'video');
                            } else {
                              await APIS.sendChatMedia(controller.user,
                                  File(controller.pickedImage.value!), 'other');
                            }
                          }
                          Navigator.pop(context);
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
                            // setState(() {
                            controller.pickedImage.value = image.path;
                            // });
                            Dialogs.showProgressIndicator(context);
                            Navigator.pop(context);

                            await APIS.sendChatMedia(controller.user,
                                File(controller.pickedImage.value!), 'image');

                            Navigator.pop(context);
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

  void callsModal() {
    var context;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Choose Action',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await APIS.addCall(controller.user);
                      },
                      child: ZegoSendCallInvitationButton(
                        onWillPressed: () {
                          APIS.addCall(controller.user);
                          ZPNsConfig zpnsConfig = ZPNsConfig();
                          ZPNs.setPushConfig(zpnsConfig);
                          ZPNs.enableDebug(true);
                          ZPNs.getInstance().registerPush();
                          ZIMPushConfig pushConfig = ZIMPushConfig();
                          pushConfig.title = "Incoming call";
                          pushConfig.content = "Call from ${APIS.user!.uid}";
                          ZIMMessageSendConfig sendConfig =
                              ZIMMessageSendConfig();
                          sendConfig.pushConfig = pushConfig;

                          ZIM
                              .getInstance()
                              ?.sendPeerMessage(
                                  ZIMTextMessage(message: 'Incoming call'),
                                  controller.user.id,
                                  sendConfig)
                              .then((value) => {})
                              .onError((error, stackTrace) => {});
                          return Future(() => true);
                        },
                        // buttonSize: Size(20, 20),
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        verticalLayout: true,
                        isVideoCall: true,
                        resourceID:
                            "zegouikit_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                        invitees: [
                          ZegoUIKitUser(
                            id: controller.user.id,
                            name: controller.user.name,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await APIS.addCall(controller.user);
                      },
                      child: ZegoSendCallInvitationButton(
                        onWillPressed: () {
                          APIS.addCall(controller.user);
                          ZPNsConfig zpnsConfig = ZPNsConfig();
                          ZPNs.setPushConfig(zpnsConfig);
                          ZPNs.enableDebug(true);
                          ZPNs.getInstance().registerPush();
                          ZIMPushConfig pushConfig = ZIMPushConfig();
                          pushConfig.title = "Incoming call";
                          pushConfig.content = "Call from ${APIS.user.uid}";
                          ZIMMessageSendConfig sendConfig =
                              ZIMMessageSendConfig();
                          sendConfig.pushConfig = pushConfig;

                          ZIM
                              .getInstance()
                              ?.sendPeerMessage(
                                  ZIMTextMessage(message: 'Incoming call'),
                                  controller.user.id,
                                  sendConfig)
                              .then((value) => {})
                              .onError((error, stackTrace) => {});
                          return Future(() => true);
                        },
                        // buttonSize: Size(20, 20),
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        verticalLayout: true,
                        isVideoCall: false,
                        resourceID:
                            "zegouikit_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                        invitees: [
                          ZegoUIKitUser(
                            id: controller.user.id,
                            name: controller.user.name,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _appBar() {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return Chatcontroller.userProfileViewScreen(controller.user: controller.user);
        // }));
      },
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          StreamBuilder(
              stream: APIS.getUserInfo(controller.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final chatUserlist =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList();
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 20,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                chatUserlist != null
                                    ? chatUserlist.first.image
                                    : controller.user.image,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chatUserlist != null
                                    ? chatUserlist.first.name
                                    : controller.user.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              chatUserlist != null &&
                                      chatUserlist.first.isOnline
                                  ? Text(
                                      'Online',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    )
                                  : Text(
                                      MyDateUtil.getlastActiveTime(
                                        context,
                                        chatUserlist != null
                                            ? chatUserlist.first.lastActive
                                            : controller.user.lastActive,
                                      ),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            callsModal();
                          },
                          child: const Icon(
                            Icons.call,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.more_vert,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
