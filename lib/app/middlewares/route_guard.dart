import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/app_controller.dart';
import '../routes/app_pages.dart';

class RouteGuard extends GetMiddleware {
  final appController = Get.find<AppController>();
  @override
  RouteSettings? redirect(String? route) {
    return (appController.isAuth.value)
        ? null
        : RouteSettings(name: Routes.SIGNIN);
  }
}
