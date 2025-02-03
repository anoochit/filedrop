import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';

import '../../appwrite.dart';

class AuthService extends GetxService {
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
  Future<void> signOut() async {
    await account.deleteSession(sessionId: 'current');
  }
}
