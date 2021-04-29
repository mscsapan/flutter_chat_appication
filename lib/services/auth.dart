import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger_app/function/helper_function.dart';
import 'package:messenger_app/screens/home.dart';
import 'package:messenger_app/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod {
  final FirebaseAuth auth = FirebaseAuth.instance;

 Future getCurrentUser() async {
    return auth.currentUser;
  }

 Future signInWithGoogle(BuildContext context) async {
    final FirebaseAuth googleAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    UserCredential result =
        await googleAuth.signInWithCredential(authCredential);
    User userResult = result.user;

    if (result != null) {
      HelperFunction().saveUserId(userResult.uid);
      HelperFunction().saveUserEmail(userResult.email);
      HelperFunction().saveUserName(userResult.email.replaceAll("@gmail.com", ""));
      HelperFunction().saveUserDisplayName(userResult.displayName);
      HelperFunction().saveUserProfileUrl(userResult.photoURL);

      Map<String, dynamic> userUpdateMap = {
        "name": userResult.displayName,
        "username": userResult.email.replaceAll("@gmail.com", ""),
        "email": userResult.email,
        "imgURL": userResult.photoURL,
      };

      UserDatabase().userDatabaseInfo(userResult.uid, userUpdateMap).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  Future signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    return await auth.signOut();
  }
}
