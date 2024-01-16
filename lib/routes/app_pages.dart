import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import 'package:osm_chat/modules/auth/forgot_password/views/forgot_password_view.dart';
import 'package:osm_chat/modules/auth/login/bindings/login_binding.dart';
import 'package:osm_chat/modules/auth/login/views/login_view.dart';
import 'package:osm_chat/modules/auth/signup/bindings/signup_binding.dart';
import 'package:osm_chat/modules/auth/signup/views/signup_view.dart';
import 'package:osm_chat/modules/chat/bindings/chat_binding.dart';
import 'package:osm_chat/modules/chat/views/chat_view.dart';
import 'package:osm_chat/modules/home/bindings/home_binding.dart';
import 'package:osm_chat/modules/home/views/home_view.dart';
import 'package:osm_chat/modules/profile/bindings/profile_binding.dart';
import 'package:osm_chat/modules/profile/views/profile_view.dart';
import 'package:osm_chat/routes/app_routes.dart';
import 'package:osm_chat/screens/chat_screen.dart';

class AppPages {
  static final initial = AppRoutes.initial;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      binding: LoginBinding(),
      page: () => const LoginView(),
    ),
    GetPage(
      name: AppRoutes.signup,
      binding: SignupBinding(),
      page: () => const SignupView(),
    ),
    GetPage(
      name: AppRoutes.forgotpass,
      binding: ForgotPasswordBinding(),
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: AppRoutes.home,
      binding: HomeBinding(),
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.chatPage,
      binding: ChatBinding(),
      page: () => const ChatView(),
    ),
    GetPage(
      name: AppRoutes.profile,
      binding: ProfileBinding(),
      page: () => const ProfileView(),
    ),
  ];
}
