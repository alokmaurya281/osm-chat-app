import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/firebase_options.dart';

class CustomController extends GetxController {
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() async {
   
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId:
            '468365634295-h3e9mtkqnq2kkqng4t9a7ktnrsa66q1v.apps.googleusercontent.com');

    if (!kIsWeb) {
      await FlutterDownloader.initialize(
          debug:
              true, // optional: set to false to disable printing logs to console (default: true)
          ignoreSsl:
              true // option: set to false to disable working with http links (default: false)
          );
    }

    await dotenv.load(fileName: ".env");
    if (!kIsWeb) {
      await AwesomeNotifications().initialize(null, [
        NotificationChannel(
          channelKey: 'calls',
          channelName: 'Calls',
          channelDescription: 'For calls',
          locked: true,
          channelShowBadge: true,
          importance: NotificationImportance.Max,
          enableVibration: true,
          enableLights: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
        ),
        NotificationChannel(
          channelKey: 'chats',
          channelName: 'Chats',
          channelDescription: 'For chats',
          channelShowBadge: true,
          importance: NotificationImportance.Max,
          enableVibration: true,
          enableLights: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ]);
    }
  }

  bool _checkUserIsLoggedIn() {
    if (APIS.auth.currentUser != null) {
      // APIS.updateActiveStatus(true);
      return true;
    } else {
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
