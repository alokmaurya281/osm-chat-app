import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osm_chat/modules/auth/signup/controllers/signup_controller.dart';
import 'package:osm_chat/routes/app_routes.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Image.asset(
                  'assets/icons/app_icon.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(246, 143, 143, 143),
                    ),
                  ),
                  child: TextFormField(
                    controller: controller.emailController,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    cursorColor: const Color.fromARGB(246, 143, 143, 143),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(246, 143, 143, 143),
                    ),
                  ),
                  child: TextFormField(
                    controller: controller.passwordController,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Password ',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    cursorColor: const Color.fromARGB(246, 143, 143, 143),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 400,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      // if (emailController.text.isNotEmpty &&
                      //     passwordController.text.isNotEmpty) {
                      //   Dialogs.showProgressIndicator(context);
                      //   await _handleEmailPasswordSignup(
                      //       emailController.text, passwordController.text);
                      //   Navigator.pop(context);
                      //   Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (context) {
                      //         return const LoginScreen();
                      //       },
                      //     ),
                      //   );
                      // } else {
                      //   Dialogs.showSnackBar(context, "All Fields Required!");
                      // }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Signup',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 400,
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return const HomeScreen();
                      //     },
                      //   ),
                      // );
                    },
                    style: TextButton.styleFrom(
                        side: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/google.png",
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an account?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.initial);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
