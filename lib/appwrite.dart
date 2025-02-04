import 'dart:developer';
import 'package:appwrite/appwrite.dart';

late Client client;
late Account account;
late Storage storage;
late Databases database;

const projectId = 'filedrop';
const databaseId = 'filedrop';
const stroageId = 'filedrop';

const initLat = 13.7563;
const initLon = 100.5018;

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
}
