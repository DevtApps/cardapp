import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'OnResult.dart';

abstract class SocialSignInModel implements OnResult {
  var CODE_EXISTS_ANOTHER_METHOD = 01;
  var CODE_INVALID_CREDENTIAL = 02;
  FirebaseAuth auth = FirebaseAuth.instance;
  void googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.requestScopes(["profile", "email"]);

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await googleSignIn.disconnect();
      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        onSuccess(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          onError(e, CODE_EXISTS_ANOTHER_METHOD);
        } else if (e.code == 'invalid-credential') {
          onError(e, CODE_INVALID_CREDENTIAL);
        }
      } on Exception catch (e) {
        onError(e, -1);
      }
    }
  }

  void facebookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]);

      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      onSuccess(userCredential);
    } on Exception catch (e) {
      onError(e, -1);
    }
  }

  Future<void> signInEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      onSuccess(userCredential);
    } on Exception catch (e) {
      onError(e, -1);
    }
  }

  Future<void> signOutEmail(String email, String password,
      {name, photo = "default"}) async {
    try {
      if (name == null) name = email.substring(0, email.indexOf("@"));
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.updatePhotoURL(photo);
      onSuccess(userCredential);
    } on Exception catch (e) {
      print(e);
      onError(e, -1);
    }
  }
}
