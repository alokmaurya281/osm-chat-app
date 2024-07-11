// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:osm_chat/modules/custom/bindings/custom_binding.dart';
import 'package:osm_chat/modules/custom/controllers/custom_controller.dart';
import 'package:osm_chat/resources/styles.dart';
import 'package:osm_chat/routes/app_pages.dart';
import 'package:osm_chat/routes/app_routes.dart';
import 'package:osm_chat/zpnhandle.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CustomController().initializeFirebase();
  ZPNsEventHandlerManager.loadingEventHandler();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService()
        .useSystemCallingUI([ZegoUIKitSignalingPlugin()]);
  });

  runApp(
    MyApp(
      navigatorKey: navigatorKey,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppStyles.lightThemeData,
      themeMode: ThemeMode.system,
      darkTheme: AppStyles.darkThemeData,
      initialBinding: CustomBinding(),
      initialRoute: AppRoutes.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,
    );
  }
}
