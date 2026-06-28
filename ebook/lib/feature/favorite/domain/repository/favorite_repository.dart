import "package:libararybd/feature/home/data/model/book_model.dart";

abstract class IFavoriteRepository {
  Future<List<BookModel>> fetchFavorites({required String token, required String userId});
  Future<List<String>> fetchFavoriteBookIds({required String token, required String userId});
  Future<List<String>> toggleFavorite({required String token, required String userId, required String bookId});
}
