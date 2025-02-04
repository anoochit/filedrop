import 'package:filedrop/app/data/models/user_nearby.dart';
import 'package:filedrop/appwrite.dart';
import 'package:geolocator/geolocator.dart';

import '../data/models/latlon.dart';

class UserNearbyService {
  // load nearby device wich lasted update
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
      if (range < 10) {
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
}
