import "package:libararybd/feature/home/data/model/book_model.dart";

abstract class IBookRepository {
  Future<List<String>> fetchCategories();
  Future<List<BookModel>> fetchBooks({String? query, String? category});
  List<String> get fallbackCategories;
  List<BookModel> get fallbackBooks;
}
