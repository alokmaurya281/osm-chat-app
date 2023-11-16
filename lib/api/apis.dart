import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:osm_chat/models/chatuser_model.dart';
import 'package:osm_chat/models/message_model.dart';
import 'package:http/http.dart' as http;

class APIS {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static get user => auth.currentUser!;
  static late ChatUser me;

  static Message? unreadMessages;

  static Future<void> getFirebasMessagingToken() async {
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.getToken().then((value) => {
          if (value != null) {me.pushToken = value}
        });
  }

  static Future<void> sendPushNotifications(
      ChatUser chatUser, String msg) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=${dotenv.env["FIREBASE_MESSAGING_KEY"]}',
        },
        body: jsonEncode({
          'to': chatUser.pushToken,
          'notification': {
            'title': auth.currentUser!.displayName,
            'body': 'New Message : $msg',
            "android_channel_id": "chats",
          }
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);
      if (response.statusCode == 200) {
        // print(auth.currentUser!.displayName);
      } else {
        print('something is wrong');
      }
    } catch (e) {
      // _isLoading = false;
      print(e.toString());
    }
  }

  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_contacts')
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      return false;
    }
  }

  static Future<void> selfInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebasMessagingToken();
        APIS.updateActiveStatus(true);
      } else {
        await createUser().then((value) => selfInfo());
      }
    });
  }

  static Future<void> updateInfo(String value, String valueKey) async {
    await firestore.collection('users').doc(user.uid).update({valueKey: value});
  }

  static Future<void> createUser() async {
    final time = DateTime.timestamp();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      about: "Hey I'm using Osm Chat",
      image: user.photoURL.toString(),
      lastActive: time.millisecondsSinceEpoch.toString(),
      email: user.email.toString(),
      isOnline: false,
      pushToken: '',
      createdAt: time.millisecondsSinceEpoch.toString(),
    );
    await firestore.collection('users').doc(user.uid).set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return APIS.firestore
        .collection('users')
        .where('id', whereIn: userIds)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyContacts() {
    return APIS.firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_contacts')
        .snapshots();
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref = firebaseStorage
        .ref()
        .child('profile_pictures/${user.uid}-profile-image.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
    me.image = await ref.getDownloadURL();
  }

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallMessages(
      ChatUser user) {
    return APIS.firestore
        .collection('chats/${getConversationId(user.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // send message

  static Future<void> sendMessage(
      ChatUser chatuser, String msg, String type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      senderId: user.uid,
      recieverid: chatuser.id,
      message: msg,
      type: type,
      sent: time,
      read: '',
    );
    final ref = firestore
        .collection('chats/${getConversationId(chatuser.id)}/messages');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotifications(chatuser, type == 'text' ? msg : 'Media'));
  }

  static Future<void> sendFirstMessage(
      ChatUser chatuser, String msg, String type) async {
    await firestore
        .collection('users')
        .doc(chatuser.id)
        .collection('my_contacts')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatuser, msg, type));
  }

  // update read status of message

  static Future<void> updateReadStatusMessage(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.senderId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    unreadMessages = unreadMessages;
    return APIS.firestore
        .collection('chats/${getConversationId(user.id)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatMedia(
      ChatUser chatuser, File file, String type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final ext = file.path.split('.').last;
    final ref = firebaseStorage
        .ref()
        .child('${type}s/${getConversationId(chatuser.id)}/$time.$ext');
    await ref.putFile(file, SettableMetadata(contentType: '$type/$ext'));
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatuser, imageUrl, type);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return APIS.firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    APIS.firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  static Future<void> updateMessage(Message message, String newmsg) async {
    firestore
        .collection('chats/${getConversationId(message.recieverid)}/messages/')
        .doc(message.sent)
        .update({
      'message': newmsg,
    });
  }

  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationId(message.recieverid)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type != 'text') {
      await firebaseStorage.refFromURL(message.message).delete();
    }
  }
}
