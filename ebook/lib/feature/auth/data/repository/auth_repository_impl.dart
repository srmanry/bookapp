import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/network/api_endpoint.dart";
import "package:libararybd/feature/auth/data/model/app_user.dart";
import "package:libararybd/feature/auth/domain/repository/auth_repository.dart";

class AuthRepositoryImpl implements IAuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoint.login,
      body: {
        "email": email.trim(),
        "password": password,
      },
    );
    return _toAuthResult(response);
  }

  @override
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoint.signUp,
      body: {
        "name": name.trim(),
        "email": email.trim(),
        "password": password,
        "role": role,
      },
    );
    return _toAuthResult(response);
  }

  AuthResult _toAuthResult(Map<String, dynamic> response) {
    final userJson =
        response["user"] as Map<String, dynamic>? ?? <String, dynamic>{};
    final token = response["token"]?.toString() ?? "";

    if (token.isEmpty) {
      throw ApiException("Login failed: missing token");
    }

    return AuthResult(
      user: AppUser.fromJson(userJson),
      token: token,
    );
  }
}
