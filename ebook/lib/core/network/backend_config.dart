import "package:libararybd/core/network/api_endpoint.dart";

class BackendConfig {
  static String get baseUrl {
    const envUrl = String.fromEnvironment("BACKEND_BASE_URL");
    if (envUrl.isNotEmpty) return envUrl;
    return ApiEndpoint.baseUrl;
  }

  static const Duration timeout = Duration(seconds: 12);
}
