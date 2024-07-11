import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/screens/video_call_screen.dart';

class CallIniviteScreen extends StatefulWidget {
  final ChatUser chatUser;
  final String callid;
  const CallIniviteScreen(
      {super.key, required this.chatUser, required this.callid});

  @override
  State<CallIniviteScreen> createState() => _CallIniviteScreenState();
}

class _CallIniviteScreenState extends State<CallIniviteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
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
                backgroundImage: CachedNetworkImageProvider(
                  widget.chatUser.image,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            widget.chatUser.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            APIS.auth.currentUser!.uid == widget.chatUser.id
                ? 'Incoming Call...'
                : 'Calling...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Transform.rotate(
                  angle: 270,
                  child: const Icon(
                    Icons.phone,
                  ),
                ),
              ),
              if (APIS.auth.currentUser!.uid == widget.chatUser.id)
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return CallPage(
                        chatUser: widget.chatUser,
                        callid: widget.callid,
                      );
                    }));
                  },
                  icon: const Icon(
                    Icons.phone,
                  ),
                )
            ],
          ),
          const Spacer()
        ],
      ),
    );
  }
}
