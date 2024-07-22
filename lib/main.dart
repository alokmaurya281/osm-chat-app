// import 'package:firebase_messaging/firebase_messaging.dart';
// ignore_for_file: unused_local_variable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:osm_chat/api/apis.dart';
// import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/providers/chat_provider.dart';
import 'package:osm_chat/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:osm_chat/screens/call_invite_screen.dart';
import 'package:osm_chat/screens/home_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'firebase_options.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

  final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService()
        .useSystemCallingUI([ZegoUIKitSignalingPlugin()]);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ChatProvider();
        })
      ],
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({
    super.key,
    required this.navigatorKey,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = _checkUserIsLoggedIn();
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: const ColorScheme.light(
          background: Colors.white,
          primary: Color.fromARGB(255, 65, 14, 160),
          onPrimary: Colors.black,
          secondary: Color.fromARGB(255, 140, 140, 140),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: const Color.fromARGB(255, 65, 14, 160),
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 24,
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        useMaterial3: true,
        primaryColor: const Color.fromARGB(255, 57, 11, 57),
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: const ColorScheme.dark(
          background: Color.fromARGB(255, 57, 11, 57),
          primary: Color.fromARGB(255, 67, 215, 245),
          onBackground: Colors.white,
          onPrimary: Colors.white,
          secondary: Color.fromARGB(255, 182, 182, 182),
        ),
        drawerTheme: const DrawerThemeData(),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 24,
          ),
          backgroundColor: Color.fromARGB(255, 57, 11, 57),
          elevation: 5,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: const Color.fromARGB(255, 67, 215, 245),
          ),
        ),
        useMaterial3: true,
        primaryColor: const Color.fromARGB(255, 57, 11, 57),
      ),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ignore: no_leading_underscores_for_local_identifiers
  GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '468365634295-1esqd7bch17d2v3ata2pn474u6ek0lq7.apps.googleusercontent.com');

  if (!kIsWeb) {
    await FlutterDownloader.initialize(
        debug:
            true, // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl:
            true // option: set to false to disable working with http links (default: false)
        );
  }

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
