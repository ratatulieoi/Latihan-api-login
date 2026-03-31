import 'dart:convert';

import 'package:flutter_assignment_login/data/models/auth_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionStorage {
  Future<void> saveSession(AuthSession session);
  Future<AuthSession?> getSession();
  Future<void> clearSession();
}

class SharedPrefsSessionStorage implements SessionStorage {
  static const _sessionKey = 'auth_session';

  @override
  Future<void> saveSession(AuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(session.toMap()));
  }

  @override
  Future<AuthSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rawSession = prefs.getString(_sessionKey);

    if (rawSession == null || rawSession.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawSession);
      if (decoded is! Map<String, dynamic>) {
        await clearSession();
        return null;
      }
      return AuthSession.fromMap(decoded);
    } on FormatException {
      await clearSession();
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
