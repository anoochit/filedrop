import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:filedrop/app/controllers/app_controller.dart';
import 'package:filedrop/app/data/models/filedrop.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

late Client client;
late Account account;
late Storage storage;
late Databases database;
late Realtime realtime;

const projectId = 'filedrop';
const databaseId = 'filedrop';
const stroageId = 'filedrop';

const initLat = 13.7563;
const initLon = 100.5018;

RealtimeSubscription? subscription;

// init appwrite client
initAppWrite() {
  // client
  log('init appwrite client');
  client = Client()
      .setEndpoint('http://10.0.2.2/v1')
      .setProject(projectId)
      .setSelfSigned(
        status: true,
      );

  // account
  account = Account(client);

  // storage
  storage = Storage(client);

  // database
  database = Databases(client);

  // realtime subscribe to database channel
  realtime = Realtime(client);

  subscription = realtime.subscribe(
    ['databases.$databaseId.collections.files.documents'],
  );

  subscription!.stream.listen((response) {
    final createEvent = response.events
        .contains('databases.$databaseId.collections.files.documents.*.create');

    final payload = response.payload;
    final to = response.payload['to'];
    final from = response.payload['from'];
    final id = response.payload['\$id'];
    final url = response.payload['url'];

    if (createEvent) {
      final appController = Get.find<AppController>();
      final currentUser = appController.currentUser;
      // is your file
      if (currentUser!.$id == to) {
        print('Document changed: $payload');
        appController.filedrop.add(
          Filedrop(id: id, from: from, to: to, url: url),
        );

        appController.update();

        final fileDropTotal = appController.filedrop.length;
        Get.snackbar(
          'You got a new file',
          'Tap to download from ${appController.filedrop[fileDropTotal - 1].url}',
          duration: Duration(seconds: 3),
          onTap: (snack) {
            print('download');
          },
        );
      }
    }
  });
}
