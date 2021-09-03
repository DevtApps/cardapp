import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  late FlutterSecureStorage storage;
  SecureStorage() {
    storage = FlutterSecureStorage();
  }

  save(key, value) async {
    return await storage.write(key: key, value: value);
  }

  read(key) async {
    return await storage.read(key: key);
  }
}
