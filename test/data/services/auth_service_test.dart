import 'dart:convert';

import 'package:flutter_assignment_login/core/errors/auth_exception.dart';
import 'package:flutter_assignment_login/data/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('DummyJsonAuthService', () {
    test('posts username/password and parses tokens from response', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode({
            'id': 1,
            'username': 'emilys',
            'firstName': 'Emily',
            'lastName': 'Johnson',
            'accessToken': 'access-token-123',
            'refreshToken': 'refresh-token-456',
          }),
          200,
        );
      });

      final service = DummyJsonAuthService(client: client);

      final session = await service.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(capturedRequest.method, 'POST');
      expect(
        capturedRequest.url.toString(),
        'https://dummyjson.com/auth/login',
      );
      expect(capturedRequest.headers['Content-Type'], 'application/json');

      final payload = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(payload['username'], 'emilys');
      expect(payload['password'], 'emilyspass');

      expect(session.username, 'emilys');
      expect(session.accessToken, 'access-token-123');
      expect(session.refreshToken, 'refresh-token-456');
    });

    test('throws API error message when server returns non-2xx', () async {
      final client = MockClient(
        (_) async =>
            http.Response(jsonEncode({'message': 'Invalid credentials'}), 400),
      );

      final service = DummyJsonAuthService(client: client);

      expect(
        () => service.login(username: 'wrong', password: 'wrong'),
        throwsA(
          isA<AuthException>().having(
            (error) => error.message,
            'message',
            'Invalid credentials',
          ),
        ),
      );
    });

    test(
      'throws friendly exception for malformed successful payload',
      () async {
        final client = MockClient(
          (_) async => http.Response(jsonEncode({'username': 'emilys'}), 200),
        );

        final service = DummyJsonAuthService(client: client);

        expect(
          () => service.login(username: 'emilys', password: 'emilyspass'),
          throwsA(
            isA<AuthException>().having(
              (error) => error.message,
              'message',
              'Unexpected server response. Please try again.',
            ),
          ),
        );
      },
    );
  });
}
