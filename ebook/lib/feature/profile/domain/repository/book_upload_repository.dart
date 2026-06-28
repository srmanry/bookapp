abstract class IBookUploadRepository {
  Future<Map<String, dynamic>> uploadBookFile({
    required String token,
    required String filePath,
  });

  Future<Map<String, dynamic>> uploadCoverImage({
    required String token,
    required String filePath,
  });

  Future<void> publishBook({
    required String token,
    required String title,
    required String authorName,
    required String category,
    required String fileUrl,
    required String fileFormat,
    String? coverUrl,
  });
}
