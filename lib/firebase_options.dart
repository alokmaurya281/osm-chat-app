// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_gCl_AsVL0ZwOhIX4U2Pm4a9nL0d1J7A',
    appId: '1:468365634295:web:a03351a62aeec3ff65c1f2',
    messagingSenderId: '468365634295',
    projectId: 'osm-chat-f2de7',
    authDomain: 'osm-chat-f2de7.firebaseapp.com',
    storageBucket: 'osm-chat-f2de7.appspot.com',
    measurementId: 'G-EDW5PX0JHP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpEsedjrntUwO9aQlmD44ITx0wyLrR6C4',
    appId: '1:468365634295:android:3629252425d83b4365c1f2',
    messagingSenderId: '468365634295',
    projectId: 'osm-chat-f2de7',
    storageBucket: 'osm-chat-f2de7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqzxaRW0FAiCmHj4-VYbFZWMf7S2elCyo',
    appId: '1:468365634295:ios:4829c54317bee2d565c1f2',
    messagingSenderId: '468365634295',
    projectId: 'osm-chat-f2de7',
    storageBucket: 'osm-chat-f2de7.appspot.com',
    androidClientId: '468365634295-1esqd7bch17d2v3ata2pn474u6ek0lq7.apps.googleusercontent.com',
    iosClientId: '468365634295-rjbvksopqoqr4bicnkbl6jev1gg11oi9.apps.googleusercontent.com',
    iosBundleId: 'com.example.osmChat',
  );

}