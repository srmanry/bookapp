import "package:libararybd/core/network/api_client.dart";
import "package:libararybd/core/network/api_endpoint.dart";
import "package:libararybd/feature/favorite/domain/repository/favorite_repository.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";

class FavoriteRepositoryImpl implements IFavoriteRepository {
  final ApiClient _apiClient;

  FavoriteRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<BookModel>> fetchFavorites({
    required String token,
    required String userId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoint.favorites(userId),
      token: token,
    );
    final rawList = response["books"] as List<dynamic>? ?? <dynamic>[];
    return rawList
        .whereType<Map<String, dynamic>>()
        .map(BookModel.fromJson)
        .toList();
  }

  @override
  Future<List<String>> fetchFavoriteBookIds({
    required String token,
    required String userId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoint.favoriteBookIds(userId),
      token: token,
    );
    final rawList =
        response["favoriteBookIds"] as List<dynamic>? ?? <dynamic>[];
    return rawList.map((item) => item.toString()).toList();
  }

  @override
  Future<List<String>> toggleFavorite({
    required String token,
    required String userId,
    required String bookId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoint.favorites(userId),
      token: token,
      body: {"bookId": bookId},
    );
    final rawList =
        response["favoriteBookIds"] as List<dynamic>? ?? <dynamic>[];
    return rawList.map((item) => item.toString()).toList();
  }
}
