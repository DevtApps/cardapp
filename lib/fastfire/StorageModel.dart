import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'OnResultStorage.dart';

abstract class StorageModel implements OnResultStorage {
  FirebaseStorage storage = FirebaseStorage.instance;

  uploadFiles(List<File> files, reference) async {
    try {
      List<String> urls = [];
      Reference ref = storage.ref(reference);
      for (File file in files) {
        var name = base64Encode(file.uri.toString().codeUnits)
            .replaceAll("/", "")
            .replaceAll("\\", "");
        UploadTask task = ref.child(name + ".jpg").putFile(file);

        TaskSnapshot last = await task;

        urls.add(await last.ref.getDownloadURL());
      }
      return urls;
    } on Exception catch (e) {
      return [] as List<String>;
    }
  }
}
