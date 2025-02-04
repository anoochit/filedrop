import 'package:filedrop/app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/app_controller.dart';
import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final appController = Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();

    if (kDebugMode) {
      emailController.text = 'demo2@example.com';
      passwordController.text = 'Hello123';
    }
  }

  signUp({required String email, required String password}) async {
    // create user data with default position
    try {
      final user = await AuthService().signupWithEmailPassword(
        email: email,
        password: password,
      );

      await AuthService().setUserData(user: user);

      Get.snackbar('Info', 'SignUp complete!');

      Get.offAllNamed(Routes.SIGNIN);
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }
}
