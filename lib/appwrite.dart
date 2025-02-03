import 'dart:developer';
import 'package:appwrite/appwrite.dart';

late Client client;
late Account account;
late Storage storage;

// init appwrite client
initAppWrite() {
  // client
  log('init appwrite client');
  client = Client()
      .setEndpoint('http://10.0.2.2/v1')
      .setProject('filedrop')
      .setSelfSigned(
        status: true,
      );

  // account
  account = Account(client);

  // storage
  storage = Storage(client);
}
