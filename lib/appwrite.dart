import 'dart:developer';

import 'package:appwrite/appwrite.dart';

late Client client;
late Account account;
late Storage storage;

initAppWrite() {
  log('init appwrite client');
  client = Client()
      .setEndpoint('http://10.0.2.2/v1')
      .setProject('filedrop')
      .setSelfSigned(
        status: true,
      );

  account = Account(client);
  storage = Storage(client);
}
