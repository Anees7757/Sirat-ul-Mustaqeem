import 'package:shared_preferences/shared_preferences.dart';

class DataSharedPrefrences {
  static SharedPreferences? _preferences;

  static const _keyBookmarkList = 'bookmarkList';
  static const _keyBookmark = 'bookmark';
  static const _keyCounter = 'counter';
  static const _keyTotal = 'total';
  static const _keyLimit = 'limit';
  static const _keyprayertc = 'prayertc';
  static const _keyasrtc = 'asrtc';
  static const _keyMarkers = 'markers';
  static const _keyLocation = 'location';
  static const _keyAddress = 'address';
  static const _keyIsFirstTime = 'isFirstTime';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setBookmarkList(List<String> bookmarkList) async =>
      await _preferences!.setStringList(_keyBookmarkList, bookmarkList);
  static List<String> getBookmarkList() =>
      _preferences!.getStringList(_keyBookmarkList) ?? [];

  static Future setBookmark(bool bookmark) async =>
      await _preferences!.setBool(_keyBookmark, bookmark);
  static bool getBookmark() => (_preferences!.getBool(_keyBookmark)) ?? false;

  static Future setCounter(int counter) async =>
      await _preferences!.setInt(_keyCounter, counter);
  static int getCounter() => (_preferences!.getInt(_keyCounter)) ?? 0;

  static Future setLimit(int limit) async =>
      await _preferences!.setInt(_keyLimit, limit);
  static int getLimit() => (_preferences!.getInt(_keyLimit)) ?? 33;

  static Future setTotal(int total) async =>
      await _preferences!.setInt(_keyTotal, total);
  static int getTotal() => (_preferences!.getInt(_keyTotal)) ?? 0;

  static Future setPrayerTC(int tc) async =>
      await _preferences!.setInt(_keyprayertc, tc);
  static int getPrayerTC() => (_preferences!.getInt(_keyprayertc)) ?? 0;

  static Future setAsrTC(String tc) async =>
      await _preferences!.setString(_keyasrtc, tc);
  static String getAsrTC() => (_preferences!.getString(_keyasrtc)) ?? "HANFI";

  static Future setMarkers(String markers) async =>
      await _preferences!.setString(_keyMarkers, markers);
  static String getMarkers() => (_preferences!.getString(_keyMarkers)) ?? "";

  static Future setCurrentLocation(String cl) async =>
      await _preferences!.setString(_keyLocation, cl);
  static String getCurrentLocation() => (_preferences!.getString(_keyLocation)) ?? "";

  static Future setCurrentAddress(String ca) async =>
      await _preferences!.setString(_keyAddress, ca);
  static String getCurrentAddress() => (_preferences!.getString(_keyAddress)) ?? "";

  static Future setIsFirstTime(bool ft) async =>
      await _preferences!.setBool(_keyIsFirstTime, ft);
  static bool getIsFirstTime() => (_preferences!.getBool(_keyIsFirstTime)) ?? true;
}