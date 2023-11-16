import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/providers/chat_provider.dart';
import 'package:osm_chat/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:osm_chat/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ChatProvider();
        })
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = _checkUserIsLoggedIn();
    return MaterialApp(
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
          // backgroundColor: Color.fromARGB(255, 57, 11, 57),
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
          // backgroundColor: Color.fromARGB(255, 57, 11, 57),
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

 await dotenv.load(fileName: ".env");
 await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing Chat messages',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
    visibility: NotificationVisibility.VISIBILITY_PUBLIC,
    allowBubbles: true,
    enableVibration: true,
    enableSound: true,
    showBadge: true,
  );
}

bool _checkUserIsLoggedIn() {
  if (APIS.auth.currentUser != null) {
    // APIS.updateActiveStatus(true);
    return true;
  } else {
    return false;
  }
}
