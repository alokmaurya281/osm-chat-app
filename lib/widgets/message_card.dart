import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/message_model.dart';
import 'package:osm_chat/utils/dialogs.dart';
import 'package:osm_chat/utils/my_date_util.dart';
import 'package:osm_chat/widgets/dialogs/edit_message_dialog.dart';
import 'package:osm_chat/widgets/option_items_message_tap.dart';

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
  // Future<void> generateAutoVideoThumb(video) async {
  //   final temp = 'assets/videos';
  //   final fileName = await VideoThumbnail.thumbnailFile(
  //     video: video.path,
  //     thumbnailPath: '$temp/${video.name}thum',
  //     imageFormat: ImageFormat.PNG,
  //     quality: 100,
  //   );
  // }

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
                color: Colors.blue.shade200,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                border: Border.all(
                  width: 2,
                  color: Colors.blue,
                )),
            child: widget.message.type != 'text'
                ? _chatImage()
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
    return Container();
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
                            //       final Directory appDirectory = await getApplicationDocumentsDirectory();
                            //       final String filePath = '${appDirectory.path}/${widget.message.senderId}.${widget.message.type}';
                            // //You can download a single file
                            // Dialogs.showProgressIndicator(context);
                            // await FileDownloader.downloadFile(
                            //     url: widget.message.message,
                            //     // name: widget.message.message,
                            //     notificationType: NotificationType
                            //         .all, //THE FILE NAME AFTER DOWNLOADING,
                            //     onProgress: (name, double progress) {
                            //       print('FILE fileName HAS PROGRESS $progress');
                            //     },
                            //     onDownloadCompleted: (String path) {
                            //       print('FILE DOWNLOADED TO PATH: $path');
                            //     },
                            //     onDownloadError: (String error) {
                            //       print('DOWNLOAD ERROR: $error');
                            //     }).then((value) => {
                            //       Navigator.pop(context),
                            //       Navigator.pop(context),
                            //     });
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
