import 'dart:convert';
import 'dart:io';

import 'package:flutter_assignment_login/core/errors/auth_exception.dart';
import 'package:flutter_assignment_login/data/models/auth_session.dart';
import 'package:http/http.dart' as http;

abstract class AuthService {
  Future<AuthSession> login({
    required String username,
    required String password,
  });
}

class DummyJsonAuthService implements AuthService {
  DummyJsonAuthService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  static final Uri _loginUri = Uri.parse('https://dummyjson.com/auth/login');

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        _loginUri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final body = _decodeBody(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return AuthSession.fromApiJson(body);
      }

      throw AuthException(
        body['message'] as String? ?? 'Login failed. Please try again.',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw AuthException('No internet connection. Please check your network.');
    } on http.ClientException catch (error) {
      throw AuthException('Network error: ${error.message}');
    } on FormatException {
      throw AuthException('Unexpected server response. Please try again.');
    }
  }

  Map<String, dynamic> _decodeBody(String source) {
    final decoded = jsonDecode(source);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const FormatException('Expected JSON object response.');
  }
}
