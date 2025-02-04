import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/controllers/app_controller.dart';
import 'app/routes/app_pages.dart';
import 'appwrite.dart';

Future<void> main() async {
  // init widget
  WidgetsFlutterBinding.ensureInitialized();

  // init appwrite
  initAppWrite();

  // init app controller
  Get.put(AppController(), permanent: true);

  // subscription file drop
  subscriptionFileDrop();

  // check current session
  await Get.find<AppController>().checkSession();

  // run app
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
