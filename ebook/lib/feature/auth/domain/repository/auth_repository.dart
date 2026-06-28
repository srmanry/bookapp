import "package:libararybd/feature/auth/data/model/app_user.dart";

class AuthResult {
  final AppUser user;
  final String token;

  const AuthResult({required this.user, required this.token});
}

abstract class IAuthRepository {
  Future<AuthResult> login({required String email, required String password});
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  });
}
