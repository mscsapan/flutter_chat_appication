import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userIDKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userDisplayNameKey = "USERDISPLAYNAMEKEY";
  static String userProfileKey = "USERPROFILEKEY";

  //Save data
  Future<bool> saveUserId(String userId) async {
    SharedPreferences id = await SharedPreferences.getInstance();
    return id.setString(userIDKey, userId);
  }

  Future<bool> saveUserName(String userName) async {
    SharedPreferences name = await SharedPreferences.getInstance();
    return name.setString(userNameKey, userName);
  }

  Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences email = await SharedPreferences.getInstance();
    return email.setString(userEmailKey, userEmail);
  }

  Future<bool> saveUserDisplayName(String userDisplay) async {
    SharedPreferences display = await SharedPreferences.getInstance();
    return display.setString(userDisplayNameKey, userDisplay);
  }

  Future<bool> saveUserProfileUrl(String userProfile) async {
    SharedPreferences profile = await SharedPreferences.getInstance();
    return profile.setString(userProfileKey, userProfile);
  }

  //get userData

  Future<String> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIDKey);
  }

  Future<String> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }

  Future<String> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }

  Future<String> getUserDisplayName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userDisplayNameKey);
  }

  Future<String> getUserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userProfileKey);
  }
}
