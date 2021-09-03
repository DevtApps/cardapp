import 'package:firebase_auth/firebase_auth.dart';

abstract class OnResult {
  void onError(Exception error, int code);
  void onSuccess(UserCredential credential);
}
