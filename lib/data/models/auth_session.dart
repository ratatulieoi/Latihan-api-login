class AuthSession {
  const AuthSession({
    required this.id,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
    this.email,
    this.firstName,
    this.lastName,
  });

  final int id;
  final String username;
  final String accessToken;
  final String refreshToken;
  final String? email;
  final String? firstName;
  final String? lastName;

  String get displayName {
    final fullName = [firstName, lastName]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(' ');

    if (fullName.isNotEmpty) {
      return fullName;
    }
    return username;
  }

  String get shortAccessToken => _shortenToken(accessToken);

  String get shortRefreshToken => _shortenToken(refreshToken);

  String _shortenToken(String token) {
    const maxChars = 18;
    if (token.length <= maxChars) {
      return token;
    }
    return '${token.substring(0, maxChars)}...';
  }

  factory AuthSession.fromApiJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'] as String?;
    final refreshToken = json['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw const FormatException('Missing access token data.');
    }

    return AuthSession(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username'] as String? ?? 'Unknown',
      accessToken: accessToken,
      refreshToken: refreshToken,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }

  factory AuthSession.fromMap(Map<String, dynamic> map) {
    final accessToken = map['accessToken'] as String?;
    final refreshToken = map['refreshToken'] as String?;

    if (accessToken == null || accessToken.isEmpty) {
      throw const FormatException('Missing stored access token.');
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      throw const FormatException('Missing stored refresh token.');
    }

    return AuthSession(
      id: (map['id'] as num?)?.toInt() ?? 0,
      username: map['username'] as String? ?? 'Unknown',
      accessToken: accessToken,
      refreshToken: refreshToken,
      email: map['email'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
