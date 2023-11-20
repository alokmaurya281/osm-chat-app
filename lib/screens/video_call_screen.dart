// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:osm_chat/utils/dialogs.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:async';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({super.key});

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   String channelName = "demo_video";
//   String token =
//       "007eJxTYGj0b1yn/ajQ+F+WxTa3Est0hnefTmcflFfVu3jxz36LfeEKDCZJFmYmZoZmBknGBiZpBmaWFpZAXpphioVRikGyWWqeQXRqQyAjA2+pEgsjAwSC+FwMKam5+fFlmSmp+QwMAO+vIG8=";

//   int uid = 0; // uid of the local user

//   int? _remoteUid; // uid of the remote user
//   bool _isJoined = false; // Indicates if the local user has joined the channel
//   late RtcEngine agoraEngine;

//   Future<void> setupVideoSDKEngine() async {
//     // retrieve or request camera and microphone permissions
//     await [Permission.microphone, Permission.camera].request();

//     //create an instance of the Agora engine
//     agoraEngine = createAgoraRtcEngine();
//     await agoraEngine
//         .initialize(RtcEngineContext(appId: dotenv.env["AGORA_APP_ID"]));

//     await agoraEngine.enableVideo();

//     // Register the event handler
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           Dialogs.showSnackBar(context,
//               "Local user uid:${connection.localUid} joined the channel");
//           setState(() {
//             _isJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           Dialogs.showSnackBar(
//               context, "Remote user uid:$remoteUid joined the channel");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           Dialogs.showSnackBar(
//               context, "Remote user uid:$remoteUid left the channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );
//   }

// // Display local video preview
//   Widget _localPreview() {
//     if (_isJoined) {
//       return AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: agoraEngine,
//           canvas: VideoCanvas(uid: 0),
//         ),
//       );
//     } else {
//       return const Text(
//         'Join a channel',
//         textAlign: TextAlign.center,
//       );
//     }
//   }

// // Display remote user's video
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: agoraEngine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: channelName),
//         ),
//       );
//     } else {
//       String msg = '';
//       if (_isJoined) msg = 'Waiting for a remote user to join';
//       return Text(
//         msg,
//         textAlign: TextAlign.center,
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     setupVideoSDKEngine();
//   }

//   // Release the resources when you leave
//   @override
//   void dispose() async {
//     super.dispose();
//     await agoraEngine.leaveChannel();
//     agoraEngine.release();
//   }

//   // Build UI
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Get started with Video Calling'),
//           ),
//           body: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             children: [
//               // Container for the local video
//               Container(
//                 height: 240,
//                 decoration: BoxDecoration(border: Border.all()),
//                 child: Center(child: _localPreview()),
//               ),
//               const SizedBox(height: 10),
//               //Container for the Remote video
//               Container(
//                 height: 240,
//                 decoration: BoxDecoration(border: Border.all()),
//                 child: Center(child: _remoteVideo()),
//               ),
//               // Button Row
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isJoined ? null : () => {join()},
//                       child: const Text("Join"),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isJoined ? () => {leave()} : null,
//                       child: const Text("Leave"),
//                     ),
//                   ),
//                 ],
//               ),
//               // Button Row ends
//             ],
//           )),
//     );
//   }

//   void join() async {
//     await agoraEngine.startPreview();

//     // Set channel options including the client role and channel profile
//     ChannelMediaOptions options = const ChannelMediaOptions(
//       clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     );

//     await agoraEngine.joinChannel(
//       token: token,
//       channelId: channelName,
//       options: options,
//       uid: uid,
//     );
//   }

//   void leave() {
//     setState(() {
//       _isJoined = false;
//       _remoteUid = null;
//     });
//     agoraEngine.leaveChannel();
//   }
// }
