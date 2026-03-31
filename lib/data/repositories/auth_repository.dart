import 'package:flutter_assignment_login/data/models/auth_session.dart';
import 'package:flutter_assignment_login/data/services/auth_service.dart';
import 'package:flutter_assignment_login/data/storage/session_storage.dart';

abstract class AuthRepository {
  Future<AuthSession?> getPersistedSession();
  Future<AuthSession> login({
    required String username,
    required String password,
  });
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required SessionStorage sessionStorage,
  }) : _authService = authService,
       _sessionStorage = sessionStorage;

  final AuthService _authService;
  final SessionStorage _sessionStorage;

  @override
  Future<AuthSession?> getPersistedSession() {
    return _sessionStorage.getSession();
  }

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final session = await _authService.login(
      username: username,
      password: password,
    );
    await _sessionStorage.saveSession(session);
    return session;
  }

  @override
  Future<void> logout() {
    return _sessionStorage.clearSession();
  }
}
