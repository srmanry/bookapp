import "package:libararybd/feature/home/data/model/book_model.dart";

abstract class IYourBookRepository {
  Future<List<BookModel>> fetchUserBooks({required String userId, required String token});
  Future<void> deleteBook({required String token, required String bookId});
}
