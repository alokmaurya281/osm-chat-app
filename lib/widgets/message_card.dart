import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/message_model.dart';
import 'package:osm_chat/utils/dialogs.dart';
import 'package:osm_chat/utils/my_date_util.dart';
import 'package:osm_chat/widgets/dialogs/edit_message_dialog.dart';
import 'package:osm_chat/widgets/option_items_message_tap.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({
    super.key,
    required this.message,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late CachedVideoPlayerController controller;
  bool isPlaying = false;

  void handleSaveButton() async {
    final status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      await Permission.manageExternalStorage.request();
    }
    if (widget.message.type == 'image') {
      if (await Directory('storage/emulated/0/OsmChat/images/').exists()) {
        final taskId = await FlutterDownloader.enqueue(
          url: widget.message.message,
          headers: {}, // optional: header send with url (auth token etc)
          savedDir: '/storage/emulated/0/OsmChat/images/',
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification: true,
          // saveInPublicStorage: true
          // click on notification to open downloaded file (for Android)
        );
      } else {
        await Directory('storage/emulated/0/OsmChat/images')
            .create(recursive: true);
        final taskId = await FlutterDownloader.enqueue(
          url: widget.message.message,
          headers: {}, // optional: header send with url (auth token etc)
          savedDir: '/storage/emulated/0/OsmChat/images/',
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification: true,
          // saveInPublicStorage: true,
        );
      }
    } else if (widget.message.type == 'video') {
      if (await Directory('storage/emulated/0/OsmChat/videos/').exists()) {
        final taskId = await FlutterDownloader.enqueue(
          url: widget.message.message,
          headers: {}, // optional: header send with url (auth token etc)
          savedDir: '/storage/emulated/0/OsmChat/videos/',
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification: true,
          // saveInPublicStorage: true
          // click on notification to open downloaded file (for Android)
        );
      } else {
        await Directory('storage/emulated/0/OsmChat/videos/')
            .create(recursive: true);
        final taskId = await FlutterDownloader.enqueue(
          url: widget.message.message,
          headers: {}, // optional: header send with url (auth token etc)
          savedDir: '/storage/emulated/0/OsmChat/videos/',
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification: true,
          // saveInPublicStorage: true,
        );
      }
    } else {
      if (await Directory('storage/emulated/0/OsmChat/other/').exists()) {
        final taskId = await FlutterDownloader.enqueue(
          url: widget.message.message,
          headers: {}, // optional: header send with url (auth token etc)
          savedDir: '/storage/emulated/0/OsmChat/other/',
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification: true,
          // saveInPublicStorage: true
          // click on notification to open downloaded file (for Android)
        );
      } else {
        await Directory('storage/emulated/0/OsmChat/other/')
            .create(recursive: true);
        final taskId = await FlutterDownloader.enqueue(
          url: widget.message.message,
          headers: {}, // optional: header send with url (auth token etc)
          savedDir: '/storage/emulated/0/OsmChat/other/',
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification: true,
          // saveInPublicStorage: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        mediaModalBottomSheet();
      },
      child: APIS.user.uid == widget.message.senderId
          ? _greenMessage()
          : _blueMessage(),
    );
  }

  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIS.updateReadStatusMessage(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                border: Border.all(
                  width: 2,
                  color: Colors.green,
                )),
            child: widget.message.type != 'text'
                ? widget.message.type == 'video'
                    ? _chatVideo()
                    : widget.message.type != 'video' &&
                            widget.message.type != 'image' &&
                            widget.message.type != 'text'
                        ? _otherMedia()
                        : _chatImage()
                : Text(
                    widget.message.message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(166, 0, 0, 0),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              // const Icon(
              //   Icons.done_all_rounded,
              //   size: 14,
              //   color: Colors.blue,
              // ),
              // const SizedBox(
              //   width: 4,
              // ),
              Text(
                MyDateUtil.getFormattedTime(context, widget.message.sent),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(
          width: 30,
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                border: Border.all(
                  width: 2,
                  color: Colors.green,
                )),
            child: widget.message.type != 'text'
                ? widget.message.type == 'video'
                    ? _chatVideo()
                    : widget.message.type != 'video' &&
                            widget.message.type != 'image' &&
                            widget.message.type != 'text'
                        ? _otherMedia()
                        : _chatImage()
                : Text(
                    widget.message.message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(166, 0, 0, 0),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              Icon(
                widget.message.read.isNotEmpty
                    ? Icons.done_all_rounded
                    : Icons.done,
                size: 14,
                color:
                    widget.message.read.isNotEmpty ? Colors.blue : Colors.grey,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                MyDateUtil.getFormattedTime(context, widget.message.sent),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chatImage() {
    return CachedNetworkImage(
      imageUrl: widget.message.message,
      placeholder: (context, url) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
      errorWidget: (context, url, child) {
        return const Icon(
          Icons.image,
          size: 80,
        );
      },
      fit: BoxFit.cover,
      width: 250,
      height: 250,
    );
  }

  Widget _chatVideo() {
    void playAndPause() {
      if (isPlaying) {
        controller.play();
      } else {
        controller.pause();
      }
    }

    controller = CachedVideoPlayerController.network(widget.message.message);
    controller.initialize().then((value) {});
    return Container(
      width: 250,
      height: 350,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isPlaying = !isPlaying;
            playAndPause();
          });
        },
        onTapCancel: () {
          setState(() {
            isPlaying = !isPlaying;
            playAndPause();
          });
        },
        child: Center(
            child: isPlaying
                ? CachedVideoPlayer(controller)
                : CachedVideoPlayer(controller)),
      ),
    );
  }

  Widget _otherMedia() {
    return Container(
      width: 250,
      height: 250,
      child: const Center(
          child: Text(
        'Preview Not Availbale! Download To view',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(221, 107, 107, 107),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      )),
    );
  }

  void mediaModalBottomSheet() {
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 285,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                children: [
                  widget.message.type == 'text'
                      ? OptionItemMessagetap(
                          icon: const Icon(
                            Icons.copy_all_rounded,
                            color: Colors.blue,
                            size: 24,
                          ),
                          name: 'Copy Text',
                          onTap: () async {
                            await Clipboard.setData(
                                    ClipboardData(text: widget.message.message))
                                .then((value) {
                              Navigator.pop(context);
                              Dialogs.showSnackBar(
                                  context, 'Message Copied SuccessFully.');
                            });
                          },
                        )
                      : OptionItemMessagetap(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.blue,
                            size: 24,
                          ),
                          name: 'Save',
                          onTap: () async {
                            handleSaveButton();
                            Navigator.pop(context);
                          },
                        ),
                  if (APIS.user.uid == widget.message.senderId)
                    Divider(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  if (APIS.user.uid == widget.message.senderId)
                    if (widget.message.type == 'text')
                      OptionItemMessagetap(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 24,
                        ),
                        name: 'Edit Message',
                        onTap: () {
                          Navigator.pop(context);

                          showDialog(
                              context: context,
                              builder: (context) {
                                return EditMessageDialog(
                                    message: widget.message);
                              });
                        },
                      ),
                  if (APIS.user.uid == widget.message.senderId)
                    OptionItemMessagetap(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 24,
                      ),
                      name: 'Unsend Message',
                      onTap: () async {
                        Dialogs.showProgressIndicator(context);
                        await APIS
                            .deleteMessage(widget.message)
                            .then((value) => {
                                  Navigator.pop(context),
                                  Navigator.pop(context),
                                  Dialogs.showSnackBar(
                                      context, "Message deleted !"),
                                });
                      },
                    ),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  OptionItemMessagetap(
                    icon: const Icon(
                      Icons.done_all_outlined,
                      color: Colors.blue,
                      size: 24,
                    ),
                    name: widget.message.read.isEmpty
                        ? 'Read At : Not Seen Yet'
                        : 'Read At : ${MyDateUtil.getLastMessageTime(context, widget.message.read)}',
                    onTap: () {},
                  ),
                  OptionItemMessagetap(
                    icon: Icon(
                      Icons.done,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 24,
                    ),
                    name:
                        'Sent At : ${MyDateUtil.getLastMessageTime(context, widget.message.sent)}',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        });
  }
}
