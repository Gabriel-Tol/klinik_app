import 'package:shared_preferences/shared_preferences.dart';

const String tokenKey = "token";
const String userIdKey = "userID";
const String usernameKey = "username";

class UserInfo {
  Future setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(tokenKey, value);
  }

  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(tokenKey);
  }

  Future setUserID(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userIdKey, value);
  }

  Future<String> getUserID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userIdKey).toString();
  }

  Future setUsername(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(usernameKey, value);
  }

  Future<String> getUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(usernameKey).toString();
  }

  Future<void> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
