import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/models/message_model.dart';
import 'package:osm_chat/routes/app_routes.dart';
import 'package:osm_chat/screens/chat_screen.dart';
import 'package:osm_chat/utils/my_date_util.dart';
import 'package:osm_chat/widgets/dialogs/profile_dialog.dart';

class ChatUserCardWidget extends StatefulWidget {
  final ChatUser user;
  const ChatUserCardWidget({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserCardWidget> createState() => _ChatUserCardWidgetState();
}

class _ChatUserCardWidgetState extends State<ChatUserCardWidget> {
 

  Message? _message;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.user.name);
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return ChatScreen(user: widget.user);
        // }));
        Get.toNamed(AppRoutes.chatPage, arguments: widget.user);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        color: const Color.fromARGB(108, 187, 231, 255),
        elevation: 0,
        child: StreamBuilder(
          stream: APIS.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              _message = list.first;
            }

            return ListTile(
              // tileColor: Colors.black,
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: const Color.fromARGB(255, 59, 255, 114),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ProfileDialog(user: widget.user);
                        });
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(widget.user.image),
                  ),
                ),
              ),
              title: Text(
                widget.user.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                _message == null
                    ? widget.user.about
                    : _message?.type == 'text'
                        ? _message!.message
                        : 'Media',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Column(
                children: [
                  _message != null &&
                          _message!.read.isEmpty &&
                          APIS.user.uid == _message!.recieverid
                      ? Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Icon(
                            Icons.notifications_active,
                            size: 20,
                            color: Colors.white,
                          ),
                        )
                      : const SizedBox(
                          height: 10,
                        ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    _message != null
                        ? MyDateUtil.getLastMessageTime(context, _message!.sent)
                        : '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
