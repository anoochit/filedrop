import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../../appwrite.dart';

class StorageService {
  final String _bucketId = 'filedrop';

  Future<File> upload({
    required Uint8List fileData,
    required String filename,
  }) async {
    try {
      return await storage.createFile(
        bucketId: _bucketId,
        fileId: ID.unique(),
        file: InputFile.fromBytes(
          bytes: fileData,
          filename: filename,
        ),
      );
    } catch (e) {
      throw ('$e');
    }
  }

  Future<Uint8List> getFile({required String fileId}) async {
    try {
      return await storage.getFileDownload(
        bucketId: _bucketId,
        fileId: fileId,
      );
    } catch (e) {
      throw ('$e');
    }
  }
}
