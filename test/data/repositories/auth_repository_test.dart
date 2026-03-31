import 'package:flutter_assignment_login/data/models/auth_session.dart';
import 'package:flutter_assignment_login/data/repositories/auth_repository.dart';
import 'package:flutter_assignment_login/data/services/auth_service.dart';
import 'package:flutter_assignment_login/data/storage/session_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthRepositoryImpl', () {
    final session = AuthSession(
      id: 1,
      username: 'emilys',
      accessToken: 'access-token-123',
      refreshToken: 'refresh-token-456',
    );

    test('loads persisted session from storage', () async {
      final fakeService = _FakeAuthService(sessionToReturn: session);
      final fakeStorage = _FakeSessionStorage()..persistedSession = session;

      final repository = AuthRepositoryImpl(
        authService: fakeService,
        sessionStorage: fakeStorage,
      );

      final result = await repository.getPersistedSession();

      expect(result?.username, 'emilys');
      expect(fakeStorage.getSessionCalls, 1);
    });

    test('login delegates to service and stores resulting session', () async {
      final fakeService = _FakeAuthService(sessionToReturn: session);
      final fakeStorage = _FakeSessionStorage();

      final repository = AuthRepositoryImpl(
        authService: fakeService,
        sessionStorage: fakeStorage,
      );

      final result = await repository.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(result.accessToken, 'access-token-123');
      expect(fakeService.lastUsername, 'emilys');
      expect(fakeService.lastPassword, 'emilyspass');
      expect(fakeStorage.savedSession?.refreshToken, 'refresh-token-456');
      expect(fakeStorage.saveSessionCalls, 1);
    });

    test('logout clears persisted session', () async {
      final fakeService = _FakeAuthService(sessionToReturn: session);
      final fakeStorage = _FakeSessionStorage()..persistedSession = session;

      final repository = AuthRepositoryImpl(
        authService: fakeService,
        sessionStorage: fakeStorage,
      );

      await repository.logout();

      expect(fakeStorage.clearSessionCalls, 1);
      expect(fakeStorage.persistedSession, isNull);
    });
  });
}

class _FakeAuthService implements AuthService {
  _FakeAuthService({required this.sessionToReturn});

  final AuthSession sessionToReturn;
  String? lastUsername;
  String? lastPassword;

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    lastUsername = username;
    lastPassword = password;
    return sessionToReturn;
  }
}

class _FakeSessionStorage implements SessionStorage {
  AuthSession? persistedSession;
  AuthSession? savedSession;
  int saveSessionCalls = 0;
  int getSessionCalls = 0;
  int clearSessionCalls = 0;

  @override
  Future<void> clearSession() async {
    clearSessionCalls++;
    persistedSession = null;
  }

  @override
  Future<AuthSession?> getSession() async {
    getSessionCalls++;
    return persistedSession;
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    saveSessionCalls++;
    savedSession = session;
    persistedSession = session;
  }
}
