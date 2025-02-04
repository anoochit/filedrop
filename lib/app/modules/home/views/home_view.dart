import 'package:filedrop/app/controllers/app_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Device'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => controller.signOut(),
            child: Text('SignOut'),
          )
        ],
      ),
      body: Column(
        children: [
          Text('${appController.currentUser!.email}'),
          Expanded(
            child: Obx(() {
              return (controller.isLoading.value)
                  ? FindUsersNearby()
                  : ListView.builder(
                      itemCount: controller.usersNearby.length,
                      itemBuilder: (BuildContext context, int index) {
                        final name = controller.usersNearby[index].name;
                        final range = controller.usersNearby[index].range;
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(name.substring(0, 2).toUpperCase()),
                          ),
                          title: Text(name),
                          trailing: Text('$range'),
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }
}

class FindUsersNearby extends StatelessWidget {
  const FindUsersNearby({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        Text('Find user nearby...'),
      ],
    ));
  }
}
