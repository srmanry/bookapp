import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/network/api_endpoint.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:libararybd/feature/profile/domain/repository/your_book_repository.dart";

class YourBookRepositoryImpl implements IYourBookRepository {
  final ApiClient _apiClient;

  YourBookRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<BookModel>> fetchUserBooks({
    required String userId,
    required String token,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoint.userBooks(userId),
      token: token,
    );
    final rawList = response["books"] as List<dynamic>? ?? <dynamic>[];
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(BookModel.fromJson)
        .toList();
  }

  @override
  Future<void> deleteBook({
    required String token,
    required String bookId,
  }) async {
    await _apiClient.delete(
      ApiEndpoint.deleteBook(bookId),
      token: token,
    );
  }
}
