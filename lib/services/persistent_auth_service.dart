import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local session metadata paired with Firebase Phone Auth.
class PersistentAuthService {
  static final PersistentAuthService instance = PersistentAuthService._();
  PersistentAuthService._();

  static const String _userPhoneKey = 'user_phone';
  static const String _userIdKey = 'user_id';
  static const String _lastLoginTimeKey = 'last_login_time';
  static const String _isLoggedInKey = 'is_logged_in';

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveLoginSession({
    required String phoneNumber,
    required String userId,
  }) async {
    final p = _prefs;
    if (p == null) {
      throw StateError('PersistentAuthService.initialize() was not called');
    }
    await p.setString(_userPhoneKey, phoneNumber);
    await p.setString(_userIdKey, userId);
    await p.setString(
      _lastLoginTimeKey,
      DateTime.now().toIso8601String(),
    );
    await p.setBool(_isLoggedInKey, true);
  }

  String? getUserPhone() => _prefs?.getString(_userPhoneKey);

  String? getUserId() => _prefs?.getString(_userIdKey);

  DateTime? getLastLoginTime() {
    final timeStr = _prefs?.getString(_lastLoginTimeKey);
    if (timeStr == null) return null;
    try {
      return DateTime.parse(timeStr);
    } catch (_) {
      return null;
    }
  }

  bool hasActiveSession() => _prefs?.getBool(_isLoggedInKey) ?? false;

  Future<void> clearSession() async {
    final p = _prefs;
    if (p == null) return;
    await p.remove(_userPhoneKey);
    await p.remove(_userIdKey);
    await p.remove(_lastLoginTimeKey);
    await p.setBool(_isLoggedInKey, false);
  }

  bool isSessionValid() {
    if (!hasActiveSession()) return false;
    final lastLogin = getLastLoginTime();
    if (lastLogin == null) return false;
    const expirationDuration = Duration(days: 30);
    return DateTime.now().difference(lastLogin) <= expirationDuration;
  }

  bool validateCurrentUser(User? currentUser) {
    if (currentUser == null) return false;
    final savedUserId = getUserId();
    return savedUserId != null && savedUserId == currentUser.uid;
  }
}
