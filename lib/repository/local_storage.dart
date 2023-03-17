import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;

  Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<bool> setToken(String key, String value) async =>
      await _prefs.setString(key, value);

  static String getToken(String key)  => 
     _prefs.getString(key)?? " ";    
}
