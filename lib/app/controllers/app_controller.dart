import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:get/get.dart';

import 'package:filedrop/appwrite.dart';

import '../services/auth_service.dart';

class AppController extends GetxController {
  //
  RxBool isAuth = false.obs;
  User? currentUser;

  // check current session
  Future<void> checkSession() async {
    try {
      final session = await AuthService().getSession();
      log('session userId = ${session.userId}');
      currentUser = await account.get();
      log('user userId = ${currentUser?.$id}');
      isAuth.value = true;
    } catch (e) {
      log('$e');
      isAuth.value = false;
    }
  }
}
