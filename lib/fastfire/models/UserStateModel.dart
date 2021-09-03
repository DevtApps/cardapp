import 'package:firebase_auth/firebase_auth.dart';

abstract class UserStateModel {
  FirebaseAuth auth = FirebaseAuth.instance;
  isLogged() {
    return auth.currentUser != null;
  }

  reloadUser() async {
    if (isLogged()) {
      try {
        await auth.currentUser!.reload();
      } catch (e) {}
    }
  }
}
