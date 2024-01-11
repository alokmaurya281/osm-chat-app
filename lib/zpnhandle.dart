import 'dart:developer';

import 'package:zego_zpns/zego_zpns.dart';

class ZPNsEventHandlerManager {
  static loadingEventHandler() {
    ZPNsEventHandler.onRegistered = (pushID) {
      log(pushID.toString());
    };
  }
}
