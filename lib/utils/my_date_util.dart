// ignore_for_file: prefer_typing_uninitialized_variables, avoid_types_as_parameter_names

import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(BuildContext context, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(BuildContext context, String time) {
    final DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sentTime.day &&
        now.month == sentTime.month &&
        now.year == sentTime.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }
    if (now.day != sentTime.day && now.year == sentTime.year) {
      return '${sentTime.day} ${getMonthString(sentTime.month).substring(0, 3)}';
    }
    return '${sentTime.day} ${getMonthString(sentTime.month).substring(0, 3)} ${sentTime.year}';
  }

  static String getDateYear(BuildContext context, String time) {
    final DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sentTime.day &&
        now.month == sentTime.month &&
        now.year == sentTime.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }
    if (now.day != sentTime.day && now.year == sentTime.year) {
      return '${sentTime.day} ${getMonthString(sentTime.month).substring(0, 3)}';
    }
    return '${sentTime.day} ${getMonthString(sentTime.month).substring(0, 3)} ${sentTime.year}';
  }

  static String getlastActiveTime(BuildContext context, String time) {
    final int i = int.tryParse(time) ?? -1;
    if (i == -1) {
      return 'Last seen not available';
    }
    final DateTime lasttime = DateTime.fromMillisecondsSinceEpoch(i);
    final DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(lasttime).format(context);
    if (now.day == lasttime.day &&
        now.month == lasttime.month &&
        now.year == lasttime.year) {
      return 'Last seen today at $formattedTime';
    }
    if ((now.difference(lasttime).inHours).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    return 'Last seen at ${lasttime.day} ${getMonthString(lasttime.month).substring(0, 3)} on $formattedTime';
  }

  static String getMonthString(num) {
    var month; //Create a local variable to hold the string
    switch (num) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
      default:
        month = "Invalid month";
    }
    return month;
  }
}
