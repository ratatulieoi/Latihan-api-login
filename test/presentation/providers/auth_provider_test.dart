import 'package:flutter_assignment_login/core/errors/auth_exception.dart';
import 'package:flutter_assignment_login/data/models/auth_session.dart';
import 'package:flutter_assignment_login/data/repositories/auth_repository.dart';
import 'package:flutter_assignment_login/presentation/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthProvider', () {
    final session = AuthSession(
      id: 1,
      username: 'emilys',
      accessToken: 'access-token-123',
      refreshToken: 'refresh-token-456',
    );

    test('init loads persisted session and sets initialized', () async {
      final fakeRepo = _FakeAuthRepository()..persistedSession = session;
      final provider = AuthProvider(authRepository: fakeRepo);

      await provider.init();

      expect(provider.isInitialized, isTrue);
      expect(provider.isAuthenticated, isTrue);
      expect(provider.session?.username, 'emilys');
      expect(fakeRepo.getPersistedSessionCalls, 1);
    });

    test('login with empty fields returns validation error', () async {
      final provider = AuthProvider(authRepository: _FakeAuthRepository());

      final result = await provider.login(username: ' ', password: '');

      expect(result, isFalse);
      expect(provider.errorMessage, 'Username dan password wajib diisi.');
      expect(provider.isAuthenticated, isFalse);
    });

    test('login success stores session and clears previous error', () async {
      final fakeRepo = _FakeAuthRepository()..loginSession = session;
      final provider = AuthProvider(authRepository: fakeRepo)..clearError();

      final result = await provider.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(result, isTrue);
      expect(provider.errorMessage, isNull);
      expect(provider.session?.refreshToken, 'refresh-token-456');
      expect(provider.isAuthenticated, isTrue);
      expect(fakeRepo.loginCalls, 1);
    });

    test('login failure from repository sets user-friendly error', () async {
      final fakeRepo = _FakeAuthRepository()
        ..loginError = AuthException('Invalid credentials');
      final provider = AuthProvider(authRepository: fakeRepo);

      final result = await provider.login(username: 'wrong', password: 'wrong');

      expect(result, isFalse);
      expect(provider.errorMessage, 'Invalid credentials');
      expect(provider.session, isNull);
      expect(provider.isAuthenticated, isFalse);
    });

    test('logout clears current session', () async {
      final fakeRepo = _FakeAuthRepository()..loginSession = session;
      final provider = AuthProvider(authRepository: fakeRepo);

      await provider.login(username: 'emilys', password: 'emilyspass');
      await provider.logout();

      expect(provider.session, isNull);
      expect(provider.isAuthenticated, isFalse);
      expect(fakeRepo.logoutCalls, 1);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  AuthSession? persistedSession;
  AuthSession? loginSession;
  Exception? loginError;

  int getPersistedSessionCalls = 0;
  int loginCalls = 0;
  int logoutCalls = 0;

  @override
  Future<AuthSession?> getPersistedSession() async {
    getPersistedSessionCalls++;
    return persistedSession;
  }

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    loginCalls++;
    if (loginError != null) {
      throw loginError!;
    }
    if (loginSession != null) {
      return loginSession!;
    }
    throw StateError('loginSession not configured for test.');
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
  }
}
