import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart';


class DownloaderCustom{

 static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }
 static String getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    } else {
      throw Exception('Could not extract filename from URL');
    }
  }

  // static Future<void> downloadFile(String url, String fileName) async {
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final directory = await getExternalStorageDirectory();
  //       if(directory == null) {
  //         print('Failed to get external storage directory');
  //         // return;
  //       }else{
  //         print(directory.path);
  //       }
  //       final customDir = Directory('${directory?.path}/OsmChat');
  //
  //       if (!await customDir.exists()) {
  //         await customDir.create(recursive: true);
  //         print('after ceatio:${customDir.path}');
  //
  //       }
  //       final filePath = '${customDir.path}/$fileName';
  //       final file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);
  //       final p = filePath;
  //       final f = File(p);
  //
  //       if (await f.exists()) {
  //         print('File exists at $p');
  //       } else {
  //         print('File does not exist at $filePath');
  //       }
  //       print('File downloaded to $filePath');
  //     } else {
  //       print('Failed to download file');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
static Future<void> downloadFile(String url, String fileName, {bool isImage= false, bool isVideo = false, bool isOthers = false}) async {
  try {
    // Check and request storage permission
    final status = await Permission.storage.status;
    if (status.isGranted) {
      print('already granted');
    }else{
     final status= await Permission.storage.request();
     // await Permission.manageExternalStorage.request();
     if(status.isGranted){
       print('granted');
     }else if(status.isPermanentlyDenied){
       print('permanently denied');
       openAppSettings();
     }
    }
    // if (!await Directory('/storage/emulated/0/Download').exists()) {
    //   await Directory('/storage/emulated/0/OsmChat').create();
    // }
    // var directory = isImage ? '/storage/emulated/0/OsmChat/Images' : isVideo ? '/storage/emulated/0/OsmChat/Videos' : '/storage/emulated/0/OsmChat/Others';
    // if (await Directory(directory).exists()) {
    //   final taskId = await FlutterDownloader.enqueue(
    //     url: url,
    //     headers: {}, // optional: header send with url (auth token etc)
    //     savedDir: directory,
    //     saveInPublicStorage: true,
    //     showNotification: true, // show download progress in status bar (for Android)
    //     openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    //   );
    // }else{
      // create new directory
      // await Directory(directory).create();
    final directory =  await getExternalStorageDirectory();
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: directory!.path,
        saveInPublicStorage: true,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    // }
   // using flutter download package


  } catch (e) {
    print('Error: $e');
  }
}

}
