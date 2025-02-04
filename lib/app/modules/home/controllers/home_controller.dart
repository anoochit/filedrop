import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:filedrop/app/data/models/user_nearby.dart';
import 'package:filedrop/app/data/models/latlon.dart';
import 'package:filedrop/app/services/usernearby_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:filedrop/app/controllers/app_controller.dart';

import '../../../../appwrite.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/location_service.dart';

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
    final users = await UserNearbyService().getUsersNearby(pos: position.value);

    users.sort((a, b) => a.range.compareTo(b.range));

    usersNearby.clear();
    usersNearby.addAll(users);

    isLoading.value = false;
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

      // TODO : update position stream
      final postionStream = LocationService().getPositionStream();
      postionSubscription = postionStream.listen((pos) {
        position.value = Latlon(lat: pos.latitude, lon: pos.longitude);
        updateCurrentPostion(pos);
        loadUserNearBy();
      });
    } catch (e) {
      // throw with init location
      setInitPosition();
      loadUserNearBy();
    }
  }
}
