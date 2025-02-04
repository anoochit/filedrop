import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:filedrop/app/controllers/app_controller.dart';
import 'package:filedrop/app/routes/app_pages.dart';
import 'package:filedrop/app/services/auth_service.dart';

class SigninController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final appController = Get.find<AppController>();

  Rx<bool> loading = false.obs;

  @override
  void onInit() {
    super.onInit();

    loading.value = false;

    if (kDebugMode) {
      emailController.text = 'demo@example.com';
      passwordController.text = 'Hello123';
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await AuthService().signinWithEmailPassword(
        email: email,
        password: password,
      );

      // set app state
      final user = await AuthService().getCurrentUser();
      appController.currentUser = user;
      appController.isAuth.value = true;

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }
}
