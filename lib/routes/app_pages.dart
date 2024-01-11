import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:osm_chat/modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import 'package:osm_chat/modules/auth/forgot_password/views/forgot_password_view.dart';
import 'package:osm_chat/modules/auth/login/bindings/login_binding.dart';
import 'package:osm_chat/modules/auth/login/views/login_view.dart';
import 'package:osm_chat/modules/auth/signup/bindings/signup_binding.dart';
import 'package:osm_chat/modules/auth/signup/views/signup_view.dart';
import 'package:osm_chat/routes/app_routes.dart';
import 'package:osm_chat/screens/home_screen.dart';

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
      // binding: LoginBinding(),
      page: () => const HomeScreen(),
    ),
  ];
}
