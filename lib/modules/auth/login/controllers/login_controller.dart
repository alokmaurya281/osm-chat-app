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
    // // Dialogs.showProgressIndicator(context);
    signInWithGoogle().then((user) async {
      if (user != null) {
        log(user.user.toString());
        if (await (APIS.userExists())) {
          Get.offNamed(AppRoutes.home);
        } else {
          await APIS.createUser();
          Get.offNamed(AppRoutes.home);
        }
      }
    });
    isLoading = false.obs;
  }

  handleEmailPasswordLogin(String email, String password) async {
    try {
      if (!kIsWeb) {
        await InternetAddress.lookup('google.com');
      }
      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on SocketException catch (e) {
      print("SocketException: $e");
      Get.showSnackbar(
        const GetSnackBar(message: 'No Internet'),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.showSnackbar(
          const GetSnackBar(message: 'No user Found'),
        );
      } else if (e.code == 'wrong-password') {
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Wrong Password',
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
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
    } catch (e) {
      print(e);
      // Dialogs.showSnackBar(context, 'Something is wrong Please try again');
    }
    return null;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
