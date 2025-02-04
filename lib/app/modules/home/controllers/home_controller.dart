import 'dart:async';
import 'dart:typed_data';

import 'package:filedrop/app/data/models/user_nearby.dart';
import 'package:filedrop/app/data/models/latlon.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:filedrop/app/controllers/app_controller.dart';

import '../../../../appwrite.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/location_service.dart';
import '../../../services/storage_service.dart';

class HomeController extends GetxController {
  final appController = Get.find<AppController>();

  StreamSubscription<Position>? postionSubscription;

  RxList<UserNearby> usersNearby = <UserNearby>[].obs;

  Rx<Latlon> position = Latlon(
    lat: initLat,
    lon: initLon,
  ).obs;

  Rx<bool> isLoading = false.obs;

  // init
  @override
  void onInit() {
    super.onInit();
    getCurrentPostion();
  }

  // cancel stream
  @override
  void dispose() {
    super.dispose();
    if (postionSubscription != null) {
      postionSubscription!.cancel();
    }
  }

  // signout
  Future<void> signOut() async {
    AuthService().signOut().then((v) {
      Get.offAllNamed(Routes.SIGNIN);
    });
  }

  // load users nearby
  Future<void> loadUserNearBy() async {
    try {
      final users = await getUsersNearby(pos: position.value);

      users.sort((a, b) => a.range.compareTo(b.range));

      usersNearby.clear();
      usersNearby.addAll(users);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  // load user nearby wich lasted update
  Future<List<UserNearby>> getUsersNearby({required Latlon pos}) async {
    //
    final users = await database.listDocuments(
      databaseId: databaseId,
      collectionId: 'users',
    );

    List<UserNearby> userNearby = [];

    for (var doc in users.documents) {
      final deivceId = doc.$id;
      final deviceName = doc.data['name'];
      final deviceLat = doc.data['lat'];
      final deviceLon = doc.data['lon'];
      final range = Geolocator.distanceBetween(
        pos.lat,
        pos.lon,
        deviceLat,
        deviceLon,
      );
      if (range < nearbyRange) {
        userNearby.add(
          UserNearby(
            id: deivceId,
            name: deviceName,
            range: range,
          ),
        );
      }
    }

    return userNearby;
  }

  // set init user position
  void setInitPosition() {
    position.value = Latlon(lat: initLat, lon: initLon);
    AuthService().setUserPostion(latlon: position.value);
  }

  // update current user position
  void updateCurrentPostion(Position pos) {
    position.value = Latlon(lat: pos.latitude, lon: pos.longitude);
    AuthService().setUserPostion(latlon: position.value);
  }

  // get current position
  Future<void> getCurrentPostion() async {
    // set init value

    try {
      // get current postion
      isLoading.value = true;
      final pos = await LocationService().checkLocationPermission();
      updateCurrentPostion(pos);
      loadUserNearBy();

      // update position stream
      // final postionStream = LocationService().getPositionStream();
      // postionSubscription = postionStream.listen((pos) {
      //   position.value = Latlon(lat: pos.latitude, lon: pos.longitude);
      //   updateCurrentPostion(pos);
      //   loadUserNearBy();
      // });
    } catch (e) {
      // throw with init location
      setInitPosition();
      loadUserNearBy();
    }
  }

  // nearby drop file
  Future<void> fileDrop(
      {required Uint8List fileData,
      required String filename,
      required String from,
      required String to}) async {
    Get.snackbar(
        'Info', 'Start upload file, you will recieve notify when file ready');
    // upload file to storage
    StorageService()
        .upload(fileData: fileData, filename: filename)
        .then((file) async {
      // get download file
      final downloadUrl =
          'http://$appwriteHost/v1/storage/buckets/$stroageId/files/${file.$id}/view?project=$projectId';

      // add file database with download url
      await database.createDocument(
        databaseId: databaseId,
        collectionId: 'files',
        documentId: file.$id,
        data: {
          'channel': 'direct',
          'to': to,
          'from': from,
          'url': downloadUrl,
        },
      );

      // notify reciever
      Get.snackbar('Info', 'File upload complete!');
    });
  }
}
