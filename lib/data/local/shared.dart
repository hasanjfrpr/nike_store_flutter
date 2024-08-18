

import 'package:nike_store_flutter/data/models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData{

static SharedPreferences? _sharedPreferences;

static Future getSharedInstance() async{

      _sharedPreferences ??= await SharedPreferences.getInstance();
}

static Future setToken(String access_token , String refresh_token) async{
  await _sharedPreferences?.setString('access_token', access_token);
  await _sharedPreferences?.setString('refresh_token', refresh_token);
}

static AuthEntity getToken() => AuthEntity(_sharedPreferences?.getString('access_token')??'', _sharedPreferences?.getString('refresh_token')??'');

static Future clearSharedPref() async=> _sharedPreferences?.clear();
 
 static Future setthemeColor(bool isLightMode) async{

  await _sharedPreferences?.setBool('lightMode', isLightMode);

 }

 static bool get lightModeStatus=> _sharedPreferences?.getBool('lightMode') ?? true;

 static Future setUsername(String userName) async{
   await _sharedPreferences?.setString('userName', userName);
 }

 static String get userName=> _sharedPreferences?.getString('userName') ?? 'کاربر مهمان';

}