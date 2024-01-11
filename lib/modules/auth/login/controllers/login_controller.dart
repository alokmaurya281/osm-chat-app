import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:osm_chat/api/apis.dart';
import 'package:osm_chat/modules/custom/controllers/custom_controller.dart';
import 'package:osm_chat/routes/app_routes.dart';

class LoginController extends CustomController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxString error = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  handleGoogleLoginButton() async {
    log('loginwithgoogle');
    isLoading = true.obs;
    signInWithGoogle().then((user) async {
      if (user != null) {
        log(user.user.toString());
        if (await (APIS.userExists())) {
          Get.offNamed(AppRoutes.home);
        } else {
          await APIS.createUser();
          Get.offNamed(AppRoutes.home);
        }
      } else {
        error = 'Please Select account'.obs;
      }
    });
    isLoading = false.obs;
  }

  handleEmailPasswordLogin(String email, String password) async {
    error = ''.obs;
    try {
      if (!kIsWeb) {
        await InternetAddress.lookup('google.com');
      }
      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(credential.toString());
    } on SocketException catch (e) {
      print("SocketException: $e");
      error = 'No Internet'.obs;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user Found'.obs;
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password'.obs;
      }
    } catch (e) {
      print(e);
      error = 'Unknown error'.obs;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    error = ''.obs;
    try {
      if (!kIsWeb) {
        await InternetAddress.lookup('google.com');
      }
      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);
        // print(userCredential);
        return userCredential;
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn(
                clientId:
                    '468365634295-h3e9mtkqnq2kkqng4t9a7ktnrsa66q1v.apps.googleusercontent.com')
            .signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        return await APIS.auth.signInWithCredential(credential);
      }
    } on SocketException catch (e) {
      print("SocketException: $e");
      // Dialogs.showSnackBar(context, 'Please Connect to internet');
      error = 'No Internet'.obs;
    } catch (e) {
      print(e);
      error = 'Something went wrog'.obs;
    }
    return null;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
