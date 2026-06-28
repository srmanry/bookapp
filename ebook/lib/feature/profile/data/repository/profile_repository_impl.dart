import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/network/api_endpoint.dart";
import "package:libararybd/feature/profile/domain/repository/profile_repository.dart";

class ProfileRepositoryImpl implements IProfileRepository {
  final ApiClient _apiClient;

  ProfileRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<Map<String, dynamic>> fetchProfile({required String token}) async {
    final response = await _apiClient.get(ApiEndpoint.profile, token: token);
    return response["profile"] as Map<String, dynamic>? ?? <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String name,
    required String email,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoint.updateProfile,
      token: token,
      body: {
        "name": name.trim(),
        "email": email.trim(),
      },
    );

    return response["profile"] as Map<String, dynamic>? ?? <String, dynamic>{};
  }
}
