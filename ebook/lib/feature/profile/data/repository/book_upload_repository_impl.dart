import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/network/api_endpoint.dart";
import "package:libararybd/feature/profile/domain/repository/book_upload_repository.dart";

class BookUploadRepositoryImpl implements IBookUploadRepository {
  final ApiClient _apiClient;

  BookUploadRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<Map<String, dynamic>> uploadBookFile({
    required String token,
    required String filePath,
  }) async {
    return await _apiClient.uploadFile(
      ApiEndpoint.uploadBook,
      filePath: filePath,
      fieldName: "file",
      token: token,
    );
  }

  @override
  Future<Map<String, dynamic>> uploadCoverImage({
    required String token,
    required String filePath,
  }) async {
    return await _apiClient.uploadFile(
      ApiEndpoint.uploadCover,
      filePath: filePath,
      fieldName: "file",
      token: token,
    );
  }

  @override
  Future<void> publishBook({
    required String token,
    required String title,
    required String authorName,
    required String category,
    required String fileUrl,
    required String fileFormat,
    String? coverUrl,
  }) async {
    await _apiClient.post(
      ApiEndpoint.books,
      token: token,
      body: {
        "title": title,
        "authorName": authorName,
        "category": category,
        "fileUrl": fileUrl,
        "fileFormat": fileFormat,
        if (coverUrl != null && coverUrl.isNotEmpty) "coverUrl": coverUrl,
      },
    );
  }
}
