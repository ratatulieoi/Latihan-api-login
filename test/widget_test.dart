import 'package:flutter_assignment_login/data/models/auth_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthSession map roundtrip keeps tokens intact', () {
    const session = AuthSession(
      id: 10,
      username: 'emilys',
      accessToken: 'access-abc',
      refreshToken: 'refresh-xyz',
      firstName: 'Emily',
      lastName: 'Johnson',
    );

    final restored = AuthSession.fromMap(session.toMap());

    expect(restored.username, 'emilys');
    expect(restored.accessToken, 'access-abc');
    expect(restored.refreshToken, 'refresh-xyz');
    expect(restored.displayName, 'Emily Johnson');
  });
}
