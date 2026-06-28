abstract class IProfileRepository {
  Future<Map<String, dynamic>> fetchProfile({required String token});
  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String name,
    required String email,
  });
}
