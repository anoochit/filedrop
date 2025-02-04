import 'dart:developer';

import 'package:geolocator/geolocator.dart';

class LocationService {
  bool serviceEnabled = false;
  late LocationPermission permission;

  // check location permission
  Future<Position> checkLocationPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('permission = denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('permission = denied forever');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  // get current position
  Future<Position> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      log('current position = ${position.latitude}, ${position.longitude}');

      return position;
    } catch (e) {
      throw ('$e');
    }
  }

  // get position stream
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        timeLimit: Duration(minutes: 5),
        distanceFilter: 5,
      ),
    );
  }
}
