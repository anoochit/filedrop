import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../../appwrite.dart';
import '../data/models/latlon.dart';

class AuthService {
  // signin
  Future<Session> signinWithEmailPassword(
      {required String email, required String password}) async {
    try {
      return await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw ('${e.message}');
    }
  }

  // signup
  Future<User> signupWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final user = await account.create(
        email: email,
        password: password,
        userId: ID.unique(),
        name: email.split('@').first,
      );
      return user;
    } catch (e) {
      throw ('$e');
    }
  }

  // get current user
  Future<User?> getCurrentUser() async {
    try {
      final user = await account.get();
      return user;
    } catch (e) {
      return null;
    }
  }

  // get session
  Future<Session> getSession() async {
    try {
      final session = await account.getSession(sessionId: 'current');
      return session;
    } catch (e) {
      throw ('$e');
    }
  }

  // signout
  Future<dynamic> signOut() async {
    return await account.deleteSession(sessionId: 'current');
  }

  // set user position
  Future<void> setUserPostion({required Latlon latlon}) async {
    //
    final user = await AuthService().getCurrentUser();

    final userId = user!.$id;

    try {
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: 'users',
        documentId: userId,
        data: {
          'lat': latlon.lat,
          'lon': latlon.lon,
          'updated': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw ('e');
    }
  }

  // set user data in database
  setUserData({required User user}) async {
    final userId = user.$id;
    final userName = user.email;
    try {
      await database.createDocument(
        databaseId: databaseId,
        collectionId: 'users',
        documentId: userId,
        data: {
          'id': userId,
          'name': userName,
          'lat': initLat,
          'lon': initLon,
          'updated': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw ('$e');
    }
  }
}
