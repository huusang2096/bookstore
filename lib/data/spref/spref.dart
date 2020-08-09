import 'package:shared_preferences/shared_preferences.dart';

///**
// * MissingPluginException (No implementation found for method getAll on channel fultter: plugin.flutter.io//share_prefernce
// * >>> http://github.com/renefloor/flutter_cached_network_image/issue/50
// *
// * cach fix:
//    Run flutter clean (or remove your building manually)
//    if u are on IOS run pod install
//    and then ==> flutter run
// */
class SPref{
  static final SPref instance = SPref._internal();
  SPref._internal();

  Future set(String key,String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  dynamic get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}