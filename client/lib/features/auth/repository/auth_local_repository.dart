
import 'package:shared_preferences/shared_preferences.dart';
class AuthLocalRepository {
  static final AuthLocalRepository _instance = AuthLocalRepository._internal();
  factory AuthLocalRepository() => _instance;
  AuthLocalRepository._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getToken() => _prefs.getString('token');

  Future<void> saveToken(String? token) async {
    if (token != null) await _prefs.setString('token', token);
  }

  Future<void> clearToken() async {
    await _prefs.remove('token');
  }
}
