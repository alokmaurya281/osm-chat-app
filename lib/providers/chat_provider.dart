import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  IconData _iconData = Icons.mic;

  IconData get iconData => _iconData;

  void setIcon(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      _iconData = Icons.send;
      notifyListeners();
    } else {
      _iconData = Icons.mic;
      notifyListeners();
    }
  }
}
