// login.dart

class Login {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  Login({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: json['access_token'] as String,
      tokenType: json['type'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }
}
