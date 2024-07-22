import 'package:flutter/material.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key, required this.chatUser, required this.callid}) : super(key: key);
  final ChatUser chatUser;
  final String callid;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 642682133,
      // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: ''
          .toString(), // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: APIS.auth.currentUser!.uid,
      userName: APIS.auth.currentUser!.displayName.toString(),
      callID: '1111',
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
