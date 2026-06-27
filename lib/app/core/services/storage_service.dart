import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';

class StorageService {
  static GetStorage get _box => GetStorage();

  static Future<void> init() async => await GetStorage.init();

  // Token
  static void saveToken(String token) =>
      _box.write(AppConstants.tokenKey, token);

  static String? getToken() => _box.read(AppConstants.tokenKey);

  static void removeToken() => _box.remove(AppConstants.tokenKey);

  // User
  static void saveUser(Map<String, dynamic> user) =>
      _box.write(AppConstants.userKey, user);

  static Map<String, dynamic>? getUser() => _box.read(AppConstants.userKey);

  static void removeUser() => _box.remove(AppConstants.userKey);

  // Auth State
  static bool get isLoggedIn => _box.read(AppConstants.isLoggedInKey) ?? false;

  static void setLoggedIn(bool val) =>
      _box.write(AppConstants.isLoggedInKey, val);

  // Chat
  static const String _chatIdKey = 'chat_id';

  static void saveChatId(String id) => _box.write(_chatIdKey, id);

  static String? getChatId() => _box.read(_chatIdKey);

  static void removeChatId() => _box.remove(_chatIdKey);

  // Appointment State
  static bool get isAppointmentBooked {
    final val = _box.read(AppConstants.isAppointmentBookedKey);
    if (val == null) return false;
    if (val is bool) return val;
    if (val is String) return val == 'true';
    return false;
  }

  static void setAppointmentBooked(bool val) =>
      _box.write(AppConstants.isAppointmentBookedKey, val.toString());

  // Clear All
  static void clearAll() => _box.erase();
}
