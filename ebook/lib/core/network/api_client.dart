import "dart:convert";

import "package:http/http.dart" as http;
import "package:libararybd/core/network/backend_config.dart";

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  final http.Client _client;
  final String baseUrl;

  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? BackendConfig.baseUrl;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
    String? token,
  }) async {
    final response = await _client
        .get(
          _buildUri(path, queryParameters),
          headers: _headers(token),
        )
        .timeout(BackendConfig.timeout);

    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client
        .post(
          _buildUri(path, null),
          headers: _headers(token),
          body: jsonEncode(body ?? <String, dynamic>{}),
        )
        .timeout(BackendConfig.timeout);

    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client
        .put(
          _buildUri(path, null),
          headers: _headers(token),
          body: jsonEncode(body ?? <String, dynamic>{}),
        )
        .timeout(BackendConfig.timeout);

    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> uploadFile(
    String path, {
    required String filePath,
    required String fieldName,
    String? token,
  }) async {
    final uri = _buildUri(path, null);
    final request = http.MultipartRequest("POST", uri);
    if (token != null && token.isNotEmpty) {
      request.headers["Authorization"] = "Bearer $token";
    }
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    final streamed = await _client.send(request).timeout(BackendConfig.timeout);
    final response = await http.Response.fromStream(streamed);
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final request = http.Request("DELETE", _buildUri(path, null));
    request.headers.addAll(_headers(token));
    if (body != null) {
      request.body = jsonEncode(body);
    }

    final streamed = await _client.send(request).timeout(BackendConfig.timeout);
    final response = await http.Response.fromStream(streamed);
    return _decodeResponse(response);
  }

  Map<String, String> _headers(String? token) {
    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  Uri _buildUri(String path, Map<String, String>? queryParameters) {
    final normalizedPath = path.startsWith("/") ? path : "/$path";
    final base = Uri.parse("$baseUrl$normalizedPath");
    return base.replace(queryParameters: queryParameters);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    Map<String, dynamic> jsonBody = <String, dynamic>{};

    if (response.body.isNotEmpty) {
      jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonBody;
    }

    final message = jsonBody["message"]?.toString() ?? "Request failed";
    throw ApiException(message, statusCode: response.statusCode);
  }
}
