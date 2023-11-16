import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/utils/my_date_util.dart';

class ChatUserProfileViewScreen extends StatefulWidget {
  final ChatUser user;
  const ChatUserProfileViewScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserProfileViewScreen> createState() =>
      _ChatUserProfileViewScreenState();
}

class _ChatUserProfileViewScreenState extends State<ChatUserProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Container(
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
                    widget.user.image,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget.user.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.user.email,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.user.about,
                          maxLines: 2,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Joined at',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          MyDateUtil.getDateYear(
                              context, widget.user.createdAt),
                          maxLines: 2,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
