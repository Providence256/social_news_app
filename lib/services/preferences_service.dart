import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_instance == null) {
      throw Exception('PreferencesService not initialized. call init() first');
    }

    return _instance!;
  }

  static Future<bool> setString(String key, String value) {
    return instance.setString(key, value);
  }

  static String? getString(String key) {
    return instance.getString(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return instance.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return instance.getBool(key) ?? defaultValue;
  }
}
