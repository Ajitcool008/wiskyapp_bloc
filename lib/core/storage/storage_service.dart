import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<bool> saveData<T>(String key, T data) async {
    if (data is String) {
      return await _prefs.setString(key, data);
    } else if (data is bool) {
      return await _prefs.setBool(key, data);
    } else if (data is int) {
      return await _prefs.setInt(key, data);
    } else if (data is double) {
      return await _prefs.setDouble(key, data);
    } else if (data is List<String>) {
      return await _prefs.setStringList(key, data);
    } else {
      // For complex objects, convert to JSON
      return await _prefs.setString(key, jsonEncode(data));
    }
  }

  T? getData<T>(String key) {
    if (T == String) {
      return _prefs.getString(key) as T?;
    } else if (T == bool) {
      return _prefs.getBool(key) as T?;
    } else if (T == int) {
      return _prefs.getInt(key) as T?;
    } else if (T == double) {
      return _prefs.getDouble(key) as T?;
    } else if (T == List<String>) {
      return _prefs.getStringList(key) as T?;
    } else {
      // For complex objects, decode from JSON
      final String? jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as T?;
    }
  }

  Future<bool> removeData(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }
}
