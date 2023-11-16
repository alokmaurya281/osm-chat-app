import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/screens/chat_user_profile_view.dart';

class ProfileDialog extends StatelessWidget {
  final ChatUser user;
  const ProfileDialog({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: [
            Text(
              user.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatUserProfileViewScreen(user: user);
                  }));
                },
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                height: 150,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
