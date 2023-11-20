// import 'dart:io';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/models/message_model.dart';
import 'package:osm_chat/providers/chat_provider.dart';
import 'package:osm_chat/screens/chat_user_profile_view.dart';
import 'package:osm_chat/screens/video_call_screen.dart';
import 'package:osm_chat/utils/dialogs.dart';
import 'package:osm_chat/utils/my_date_util.dart';
import 'package:osm_chat/widgets/message_card.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? pickedImage;
  late IconData icon;
  @override
  void initState() {
    super.initState();
    icon = Icons.mic;
  }

  TextEditingController messageController = TextEditingController();
  List<Message> list = [];
  bool _showEmoji = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
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
                  stream: APIS.getallMessages(widget.user),
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
                        list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (list.isEmpty) {
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
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return MessageCard(
                                message: list[index],
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
                child: _chatInputField(context, messageController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatInputField(
      BuildContext context, TextEditingController messageController) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
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
                      provider.setIcon(messageController);
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
                      // prefixIcon: GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       _showEmoji = !_showEmoji;
                      //     });
                      //   },
                      //   child: const Icon(
                      //     Icons.emoji_emotions,
                      //   ),
                      // ),
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
                    if (list.isEmpty) {
                      APIS.sendFirstMessage(
                          widget.user, messageController.text, 'text');
                      messageController.text;
                      messageController.clear();
                    } else {
                      APIS.sendMessage(
                          widget.user, messageController.text, 'text');
                      messageController.text;
                      messageController.clear();
                    }
                  } else {
                    Dialogs.showSnackBar(context, "Enter Message");
                  }
                },
                icon: Icon(
                  provider.iconData,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
          ],
        );
      },
    );
  }

  void mediaModalBottomSheet() {
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
                            setState(() {
                              pickedImage = element.path;
                            });
                            await APIS.sendChatMedia(
                                widget.user, File(pickedImage!), 'document');
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

                            setState(() {
                              pickedImage = element.path;
                              // print('${element.name} Hiii');
                            });

                            if (imageMimeTypes.contains(ext)) {
                              await APIS.sendChatMedia(
                                  widget.user, File(pickedImage!), 'image');
                            } else if (videoMimeTypes.contains(ext)) {
                              await APIS.sendChatMedia(
                                  widget.user, File(pickedImage!), 'video');
                            } else {
                              await APIS.sendChatMedia(
                                  widget.user, File(pickedImage!), 'other');
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
                            setState(() {
                              pickedImage = image.path;
                            });
                            Dialogs.showProgressIndicator(context);
                            Navigator.pop(context);

                            await APIS.sendChatMedia(
                                widget.user, File(pickedImage!), 'image');

                            Navigator.pop(context);
                          } else {
                            // ignore: use_build_context_synchronously
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

  Widget _appBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatUserProfileViewScreen(user: widget.user);
        }));
      },
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          StreamBuilder(
              stream: APIS.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final chatUserlist =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList();
                return Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    : widget.user.image,
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
                                    : widget.user.name,
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
                                            : widget.user.lastActive,
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     GestureDetector(
                    //       child: const Icon(
                    //         Icons.call,
                    //         size: 20,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 12,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         // Navigator.push(context,
                    //         //     MaterialPageRoute(builder: (context) {
                    //         //   return VideoCallScreen();
                    //         // }));
                    //       },
                    //       child: const Icon(
                    //         Icons.video_call,
                    //         size: 20,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 12,
                    //     ),
                    //     GestureDetector(
                    //       child: const Icon(
                    //         Icons.more_vert,
                    //         size: 20,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 16,
                    //     ),
                    //   ],
                    // ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
