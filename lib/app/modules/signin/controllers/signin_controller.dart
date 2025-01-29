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

  Future<void> signIn({required String email, required String password}) async {
    try {
      await AuthService().signinWithEmailPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }
}
