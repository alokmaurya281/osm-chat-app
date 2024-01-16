import 'package:osm_chat/api/apis.dart';

class AppRoutes {
  static final initial = APIS.auth.currentUser != null ? '/home' : '/login';
  static const signup = '/signup';
  static const login = '/login';
  static const forgotpass = '/forgotpassword';
  static const home = '/home';
  static const chatPage = '/chat_screen';
  static const profile = '/profile';
}
