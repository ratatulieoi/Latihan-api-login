import 'package:flutter/foundation.dart';
import 'package:flutter_assignment_login/core/errors/auth_exception.dart';
import 'package:flutter_assignment_login/data/models/auth_session.dart';
import 'package:flutter_assignment_login/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthSession? _session;
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _restoredFromLocalStorage = false;
  String? _errorMessage;

  AuthSession? get session => _session;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get restoredFromLocalStorage => _restoredFromLocalStorage;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _session != null;
  String get sessionSourceLabel {
    if (_restoredFromLocalStorage) {
      return 'Local Storage';
    }
    if (_session != null) {
      return 'API + cache lokal';
    }
    return '-';
  }

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    _setLoading(true);
    try {
      _session = await _authRepository.getPersistedSession();
      _restoredFromLocalStorage = _session != null;
    } catch (_) {
      _session = null;
      _restoredFromLocalStorage = false;
    } finally {
      _isInitialized = true;
      _setLoading(false);
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final trimmedUsername = username.trim();
    final trimmedPassword = password.trim();

    if (trimmedUsername.isEmpty || trimmedPassword.isEmpty) {
      _errorMessage = 'Username dan password wajib diisi.';
      notifyListeners();
      return false;
    }

    _errorMessage = null;
    _setLoading(true);

    try {
      final result = await _authRepository.login(
        username: trimmedUsername,
        password: trimmedPassword,
      );
      _session = result;
      _restoredFromLocalStorage = false;
      return true;
    } on AuthException catch (error) {
      _session = null;
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _session = null;
      _errorMessage = 'Terjadi kesalahan. Coba lagi sebentar.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authRepository.logout();
      _session = null;
      _restoredFromLocalStorage = false;
      _errorMessage = null;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
