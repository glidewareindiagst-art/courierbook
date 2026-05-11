import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service to handle persistent login/logout and session management
class PersistentAuthService {
  static final PersistentAuthService instance = PersistentAuthService._();
  PersistentAuthService._();

  static const String _userPhoneKey = 'user_phone';
  static const String _userIdKey = 'user_id';
  static const String _lastLoginTimeKey = 'last_login_time';
  static const String _isLoggedInKey = 'is_logged_in';

  late SharedPreferences _prefs;

  /// Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save login session after successful authentication
  Future<void> saveLoginSession({
    required String phoneNumber,
    required String userId,
  }) async {
    try {
      await _prefs.setString(_userPhoneKey, phoneNumber);
      await _prefs.setString(_userIdKey, userId);
      await _prefs.setString(
        _lastLoginTimeKey,
        DateTime.now().toIso8601String(),
      );
      await _prefs.setBool(_isLoggedInKey, true);
    } catch (e) {
      throw Exception('Failed to save login session: $e');
    }
  }

  /// Retrieve saved user phone number
  String? getUserPhone() {
    return _prefs.getString(_userPhoneKey);
  }

  /// Retrieve saved user ID
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// Get last login time
  DateTime? getLastLoginTime() {
    final timeStr = _prefs.getString(_lastLoginTimeKey);
    if (timeStr != null) {
      try {
        return DateTime.parse(timeStr);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Check if user has an existing session
  bool hasActiveSession() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Clear all session data (logout)
  Future<void> clearSession() async {
    try {
      await _prefs.remove(_userPhoneKey);
      await _prefs.remove(_userIdKey);
      await _prefs.remove(_lastLoginTimeKey);
      await _prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      throw Exception('Failed to clear session: $e');
    }
  }

  /// Check if session is still valid (optional: add expiration logic)
  bool isSessionValid() {
    if (!hasActiveSession()) {
      return false;
    }

    final lastLogin = getLastLoginTime();
    if (lastLogin == null) {
      return false;
    }

    // Session valid for 30 days
    final expirationDuration = Duration(days: 30);
    final isExpired = DateTime.now().difference(lastLogin) > expirationDuration;

    return !isExpired;
  }

  /// Validate Firebase user matches saved session
  bool validateCurrentUser(User? currentUser) {
    if (currentUser == null) {
      return false;
    }

    final savedUserId = getUserId();
    return savedUserId == currentUser.uid;
  }
}
